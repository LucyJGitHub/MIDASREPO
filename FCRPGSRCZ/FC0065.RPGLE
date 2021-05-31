     H DEBUG
      ********************************************************************
/*STD *  RPGBASEBND                                                      *
/*EXI *  TEXT('Midas FC Review reporting (part 2)')
      ********************************************************************
      *                                                                  *
      *  Midas - Report Control Facility Module                          *
      *                                                                  *
      *      FC0065 - SPOOL FILE ENQUIRY                                 *
      *                                                                  *
      *  (c) Finastra International Limited 2001                         *
      *                                                                  *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 TDA035             Date 02Apr04               *
      *                 CAAA02             Date 02Dec03               *
      * Midas Release 4 --------------- Base ----------------------------*
      * Midas DBA 3.03 --------------------------------------------------*
      *                 142799             Date 27Apr00                  *
      * Midas DBA 3.00 ---------------- Base ----------------------------*
      *                 087380             Date 10May95                  *
      *                 043702             Date 21Aug92                  *
      *                 S01117             Date 25Mar92                  *
      *                 S01269             Date 25Jun91                  *
      *                 LN1153             Date 09May91                  *
      *                 LN1186             Date 06Mar91                  *
      *                 LN1142             Date 14Feb91                  *
      *                 LN0912             Date 30Oct90                  *
      *                 LN0852             Date 16Oct90                  *
      *                 LN0851             Date 12Oct90                  *
      *                 LN0669             Date 06Sep90                  *
      *                 LN0366             Date 13Jun90                  *
      *                                                                  *
      ********************************************************************
      *                                                                  *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CAAA02 - Modified for MidasPlus so that output can connect to   *
      *           a HTML page using Websettings (*%%WB lines)            *
      *           Remove the processing for diplaying a spoolfile using  *
      *           DSPSPLF commamd                                        *
      *           Array INS changed to remove the 5=View                 *
      *  142799 - Some reports were not distributed by RCF. Fix is to    *
      *           change the key for FCSFNOL0, FCSFNOL1, FCYFNOL0,       *
      *           FCYFNOL1.                                              *
      *  087380 - Enlarge parameter for AOUSERR0                         *
      *  043702 - CHANGE TO ALLOW FOR NEW STATUS VALUE:                  *
      *              'F' = DISTRIBUTION FAILED                           *
      *  S01117 - RECOMPILE FOR FT CHANGE TO MUSERDD                     *
      *  S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO            *
      *           MUSERDD                                                *
      *  LN1153 - 1. SEND DIFFERENT MESSAGE IF SELECTOR FIELD IS         *
      *              INVALID.                                            *
      *           2. ENSURE THAT IF FIELD IS CHANGED FROM 'YES' TO       *
      *              'NO' THAT THE FIELD IS BLANKED PROPERLY FIRST.      *
      *           3. DO NOT SEND RCF1034 & RCF1035 AT THE SAME TIME.     *
      *  LN1186 - SEND NEW MESSAGE ID FROM FCUSRMSG TO FCC0240           *
      *  LN1142 - AMEND TEXT FOR AUDIT REPORTS ON SPOOL FILE SCREEN      *
      *  LN0912 - AMEND SCREEN FORMAT AND PROCESSING FOR CHANGE          *
      *           COPY AND DELETE SPOOL FILE.                            *
      *  LN0852 - DEFINE FIELD SSFNO AND REMOVE 2 REDUNDANT LINES.       *
      *  LN0851 - AMEND PROCESSING FOR ERROR PARAMETER RECEIVED          *
      *           FROM FCC0260.                                          *
      *           ADD EXTRA PARAMETER ON CALL TO FCC0260 - REPORT        *
      *           REQUEST NUMBER.                                        *
      *  LN0669 - STANDARDISE SCREEN APPEARANCE                          *
      *  LN0366 - BLANK OUT SELECT FIELD IF IN ERROR & CMD12 SELECTED    *
      *                                                                  *
      ********************************************************************
     FFC0060DF  CF   E             WORKSTN
     F                                     SFILE(FC0065S1:RRN)
     FFCRREQL1  IF   E           K DISK
     FFCYREQL1  IF   E           K DISK
     FFCSFNOL1  IF   E           K DISK
     FFCYFNOL1  IF   E           K DISK
     FFCSFNOL0  UF   E           K DISK
     FFCYFNOL0  UF   E           K DISK
     F*                                                               *
     F* INSERT STANDING DATA FILE - OFFICE MODULE                     *
     F*                                                               *
     F********************************************************************
     F*             FUNCTION OF INDICATORS
     F*
     F*  03         FUNCTION KEY 3 TAKEN FROM SCREEN
     F*  12         FUNCTION KEY 12 TAKEN FROM SCREEN
     F*  20         SFLDSP INDICATOR
     F*  21         SFLDSPCTL INDICATOR
     F*  22         SFLEND INDICATOR
     F*  23         SFLCLR INDICATOR
     F*  24         SFLINZ INDICATOR
     F*  25         SFLNXTCHG INDICATOR
     F*  30         SELECTION NOT 'CHANGE' OR 'COPY'
     F*  31         SELECTION FOR 'COPY' ONLY
     F*  33         PROTECT SCREEN INPUT
     F*  40         ERROR ON SELECTION CODE
     F*  41         ERROR ON 'USER FOR OUTPUT'
     F*  42         ERROR ON DISTRIBUTION LISTS
     F*  43         ERROR ON 'OUTPUT QUEUE'
     F*  44         ERROR ON 'SAVE'                                       LN0912
     F*  45         ERROR ON 'HOLD'                                       LN0912
     F*  46         ERROR ON NO. OF COPIES                                LN0912
     F*  50         NOT MULTIBRANCHED
     F*  51         OFFICE PRESENT
     F*  60         SUBFILE ERROR MESSAGE END
     F*  71         UNSUCCESSFUL CHAIN OF REPORT REQ.FILES
     F*  75         ENTRY IS VALID
     F*  80         STANDARD OUTPUT INSTRUCTIONS NOT FOUND
     F*  83         READ CHANGED SUBFILE RECORDS
     F*  89         ERROR ON SCREEN
     F*
     F********************************************************************
      **
      **
      **
      **
      **
     F********************************************************************
     F*             INDEX OF SUBROUTINES
     F*
     F*  INIT       INITIAL PROCESSING
     F*  INSTR      ARRANGE INSTRUCTION FOR FOOTER
     F*  PCHG       VALIDATE SUBFILE
     F*  PSEL       PROCESS SUBFILE
     F*  DSPSFL     DISPLAY SPOOL FILE ENTRY
     F*  DLTSFL     DELETE SPOOL FILE ENTRY
     F*  RLSSFL     RELEASE SPOOL FILE ENTRY
     F*  HLDSFL     HOLD SPOOL FILE                                       LN0912
     F***MOVSFL*****MOVE*SPOOL*FILE*TO*A*DIFFERENT*OUTPUT*QUEUE****       LN0912
     F*  CHGSFL     CHANGE ATTRIBS (OUTQ, COPIES, SAVE) FOR SPOOL FILE    LN0912
     F*             AND CALL HLDSFL/RLSSFL AS REQUIRED                    LN0912
     F*  CPYSFL     COPY SPOOL FILE USING SNDNETSPLF
     F*  VALDTL     PERFORM VALIDATION OF DETAIL SCREEN
     F*  *PSSR      SYSTEM RECOVERY
     F*  RTV        RETRIEVE DETAILS FROM REPORT REQ.FILES
     F*  SSUB       SET UP SUBFILE FOR DISPLAY
     F*  UPD        UPDATE CHANGES TO DB FILE: FCSFNOL0/FCYFNOL0
     F*  VALA       VALIDATE MAIN SCREEN
     F*  VALB       VALIDATE SELECTION ON SUBFILE
     F*
     F********************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D INS             S             70    DIM(3) CTDATA PERRCD(1)
     D**********          TXT     1   3 22                                LN1142
     D TXT             S             23    DIM(4) CTDATA PERRCD(1)                               LN1
     D**********          ARR     1   9 35                                LN0912
     D ARR             S             35    DIM(11) CTDATA PERRCD(1)                              LN0
     D JOB             S              1    DIM(21)
     D*
     D** REPORT SUFFIXES FROM REPORT DESCRIPTION
     D*
     D********************************************************************
      /EJECT
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * 200 BYTE DATASTRUCTURE FOR ACCESS PROGRAMS
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)                       087380
      * 800 BYTE DATASTRUCTURE FOR ACCESS PROGRAMS                        087380
      *                                                                   087380
     D P@USER        E DS                  EXTNAME(MUSER)
      * LF/MUSER ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
     D*P@RSFX***     E DS                  EXTNAME(FCRSFXPD)                                MD055265
     D P@RSFX        E DS                  EXTNAME(FCRSFCTD)                                MD055265
      * LF/FCRSFXL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
     D P@RCF         E DS                  EXTNAME(SDRCFPD)
      * LF/SDRCFL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
     D REQKDS          DS
     D  @RNAM                  1     10
     D  @RQSQ                 11     15
     D*
     D FILJOB          DS            50
     D*
     D** FILE NAME AND JOB NAME DATA STRUCTURE FOR QCMDEXC
     D*
     D  RSFX                   6     15
     D  PJBNB                 22     27
     D  JBDTLS                29     50
     D SPLDTL          DS            30
     D*
     D**  SPOOL FILE NUMBER FOR QCMDEXC
     D*
     D  SFNO                  10     15
     D OTQDTL          DS            30
     D*
     D**  OUTPUT QUEUE NAME FOR QCMDEXC
     D*
     D  TOOUTQ                 6     15
     D DIRIDD          DS            35
     D*
     D**  DIRECTORY/NAME DETAILS FOR SNDNETSPLF VIA QCMDEXC
     D*
     D  DLS1                  11     18
     D  DLS2                  22     29
     D CMDEXC          DS
     D*
     D**  FULL COMMAND STREAM FOR QCMDEXC
     D*
     D  CMD                    1     30
     D  FILDTL                31     80
     D  SFDETL                81    110
     D  OUTQDT               111    140
     D  DIRDTL               141    175
     D  COPSAV               176    200                                         LN0912
     D  NUMCOP               183    184                                         LN0912
     D  SAVEYN               193    195                                         LN0912
     D*                                                                   LN0912
     D** DATA STRUCTURE FOR MANIPULATING NUMBER OF COPIES                 LN0912
     D*                                                                   LN0912
     D                 DS                                                       LN0912
     D  CPYS5A                 1      5                                         LN0912
     D  CPYS2A                 2      3                                         LN0912
     D  CPYS2                  2      2                                         LN0912
     D  CPYS3                  3      3                                         LN0912
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
     D PSDS           SDS
     D*
     D** PROGRAM STATUS DATA STRUCTURE FOR USER ETC.
     D*
     D  JBNM                 244    253
     D  JUSR                 254    263
     D  JBNB                 264    269
     D*
      * AOSVALR0 Call to access object fields                                                 CAAA02
     d @RTCD           s              7                                                       CAAA02
     D SVALKK          C                   CONST('iWAMachineAndPortNbr')                      CAAA02
      *                                                                                       CAAA02
     D JobSPL          C                   CONST('/webaccess/iWASpoolViewer?+                 CAAA02
     D                                           jobInfo=')                                   CAAA02
     D JobPDF          C                   CONST('/webaccess/iWAPDFDownload?+                 CAAA02
     D                                           jobInfo=')                                   CAAA02
     D JobPCL          C                   CONST('/webaccess/iWAPclDownload?+                 CAAA02
     D                                           jobInfo=')                                   CAAA02
     D JobInfo1        S             40                                                       CAAA02
     d FilStr          s             20                                                       CAAA02
     d JobStr          s             26                                                       CAAA02
     d SplNbr          s             16                                                       CAAA02
     I********************************************************************
      /EJECT
     C*
      ** Input Parameters:
      **          User
      **          Entity
      **          Report name
      **          Report Description
      **          Sequence Number
      **          Reporting day(T= today, Y=yesterday)
      **          Required Termination
      *
     C                   MOVEA     CPY@          BIS@             80
      *
     C     *ENTRY        PLIST
     C                   PARM                    @USER
     C                   PARM                    @ETTY
     C     @RNAM         PARM                    RNAM
     C                   PARM                    @RDES
     C     @RQSQ         PARM                    RQSQ
     C                   PARM                    @RPTD             1
     C                   PARM                    @RTERM            1
      *
     C     *LIKE         DEFINE    D5RNAM        RNAM
     C     *LIKE         DEFINE    D5RQSQ        RQSQ
     C*
      ** Perform Initial Processing
      ** - Retrieve details from DB files
      ** - display first screen
     C** - Process and write Subfile
     C*
     C                   EXSR      INIT
     C*
      ** Main Line Processing
      ** - Validate subfile
      ** - Process Subfile
     C*
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C                   EXSR      PCHG
      *
     C     *IN75         IFEQ      '0'
     C                   EXSR      PSEL
     C                   ELSE
     C                   WRITE     FC0060C0
     C                   EXFMT     FC0065C1
     C                   END
      *
     C                   END
      *
      ** IF Command key 12 has been taken
      ** Return to CALLING PGM
      *
     C     *IN12         IFEQ      '1'
     C                   SETOFF                                       12
     C**                                                                  LN0366
     C**  BLANK OUT SSEL AND REVERSE IMAGE IF CMD.12 SELECTED             LN0366
     C**                                                                  LN0366
     C                   MOVE      *BLANKS       SSEL                                          LN036
     C                   SETOFF                                       40                       LN036
     C*                                                                   LN0366
     C                   RETURN
     C                   END
     C*
      ** Termination Processing
     C*
     C     *IN03         IFEQ      '1'
     C                   MOVE      'T'           @RTERM
     C                   SETON                                        LR
     C                   RETURN
     C                   END
     C*
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R INIT  - Initial Processing
     C*  CALLED FROM MAIN
     C*  CALLS - RTV, SSUB
     C*
     C********************************************************************
      *
     C     INIT          BEGSR
      *
      **  Set up program name field for LDA                               LN0851
     C                   MOVEL     'FC0065'      DBPGM                                         LN085
      **  Access Dataarea RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** If the bank is not multibranched
      ** set on indicator - 50
      *
     C     MBIN          IFEQ      'N'
     C                   MOVE      '1'           *IN50
     C                   END
      *
      **  Access File SDRCFPD
      **  Test if Office is on the system
      *
     C                   CALL      'AORCFR0'
     C                   PARM      '*DBERR'      P@APRC                           B:Return code
     C                   PARM      '*FIRST'      P@APOP                           B:Return code
     C     P@RCF         PARM      P@RCF         DSFDY                            O:Rec format
      *
     C     D0OFPR        IFEQ      'Y'
     C                   SETON                                        51
     C                   END
      *
     C                   MOVE      JBNM          WSID
      *
      ** Check that user exists on LF/MUSER
      ** Access MUSER for current user
      *
     C                   CALL      'AOUSERR0'
     C                   PARM      '*DBERR'      P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM                    JUSR                             I:User profile
     C***********P@USER    PARM P@USER    DSFDY              O:Rec format 087380
     C     P@USER        PARM      P@USER        DSSDY                            O:Rec format 08738
     C*
     C** Access to Multi users reports
     C*
     C                   MOVEL     MUREP         @MUSER            1
     C*
     C** Access to Multi branch reports
     C*
     C                   MOVEL     MBREP         @MBRCH            1
     C*
     C** can change output
     C*
     C                   MOVEL     ROUT          @AUT              1
     C*
     C** has an output queue
     C*
     C                   MOVEL     OUTQ          @OUTQ            10
      *                                                                                       CAAA02
      * Call SDRTVTXT pgm to access appropriate text                                          CAAA02
      *  for a field used in a SFL                                                            CAAA02
      *                                                                                       CAAA02
      * Spool                                                                                 CAAA02
     C                   MOVEL     'ZZGBMSGF'    MSGNM                                        CAAA02
     C                   MOVEL     'ZZO1441'     MSGDNB                                       CAAA02
     C                   CALL      'SDRTVTXT'                                                 CAAA02
     C                   PARM                    MSGDNB            7                          CAAA02
     C                   PARM                    MSGNM            10                          CAAA02
     C                   PARM                    MSGTXT           80                          CAAA02
     C                   MOVEL     MSGTXT        ZZM058            6                          CAAA02
      *                                                                                       CAAA02
      * PDF                                                                                   CAAA02
     C                   MOVEL     'ZZN9775'     MSGDNB                                       CAAA02
     C                   CALL      'SDRTVTXT'                                                 CAAA02
     C                   PARM                    MSGDNB                                       CAAA02
     C                   PARM                    MSGNM                                        CAAA02
     C                   PARM                    MSGTXT                                       CAAA02
     C                   MOVEL     MSGTXT        ZZM059            3                          CAAA02
      *                                                                                       CAAA02
      * PCL                                                                                   CAAA02
     C                   MOVEL     'ZZO1433'     MSGDNB                                       CAAA02
     C                   CALL      'SDRTVTXT'                                                 CAAA02
     C                   PARM                    MSGDNB                                       CAAA02
     C                   PARM                    MSGNM                                        CAAA02
     C                   PARM                    MSGTXT                                       CAAA02
     C                   MOVEL     MSGTXT        ZZM060            3                          CAAA02
      *                                                                                       CAAA02
      ** Call AOSVALR0 to get the system value for the iSeries Access for Web                 CAAA02
      ** machine and port                                                                     CAAA02
      *                                                                                       CAAA02
     C                   CALL      'AOSVALR0'                                                 CAAA02
     C                   PARM                    @RTCD                                        CAAA02
     C                   PARM      SVALKK        SVALK1           20                          CAAA02
     C                   PARM                    SVAL1           200                          CAAA02
     C                   PARM                    SVALK2           20                          CAAA02
     C                   PARM                    SVAL2           200                          CAAA02
     C                   PARM                    SVALK3           20                          CAAA02
     C                   PARM                    SVAL3           200                          CAAA02
     C                   PARM                    SVALK4           20                          CAAA02
     C                   PARM                    SVAL4           200                          CAAA02
     C                   PARM                    SVALK5           20                          CAAA02
     C                   PARM                    SVAL5           200                          CAAA02
     C                   PARM                    SVALK6           20                          CAAA02
     C                   PARM                    SVAL6           200                          CAAA02
     C                   PARM                    SVALK7           20                          CAAA02
     C                   PARM                    SVAL7           200                          CAAA02
     C                   PARM                    SVALK8           20                          CAAA02
     C                   PARM                    SVAL8           200                          CAAA02
     C                   PARM                    SVALK9           20                          CAAA02
     C                   PARM                    SVAL9           200                          CAAA02
     C                   PARM                    SVALK0           20                          CAAA02
     C                   PARM                    SVAL10          200                          CAAA02
      *                                                                                       CAAA02
     C     @RTCD         IFNE      *BLANKS                                                    CAAA02
                                                                                              CAAA02
     C     SVAL10        IFEQ      '*NRF'                                                     CAAA02
     C                   MOVE      SVALK0        DBKEY                                        CAAA02
     C                   ENDIF                                                                CAAA02
     C     SVAL9         IFEQ      '*NRF'                                                     CAAA02
     C                   MOVE      SVALK9        DBKEY                                        CAAA02
     C                   ENDIF                                                                CAAA02
     C     SVAL8         IFEQ      '*NRF'                                                     CAAA02
     C                   MOVE      SVALK8        DBKEY                                        CAAA02
     C                   ENDIF                                                                CAAA02
     C     SVAL7         IFEQ      '*NRF'                                                     CAAA02
     C                   MOVE      SVALK7        DBKEY                                        CAAA02
     C                   ENDIF                                                                CAAA02
     C     SVAL6         IFEQ      '*NRF'                                                     CAAA02
     C                   MOVE      SVALK6        DBKEY                                        CAAA02
     C                   ENDIF                                                                CAAA02
     C     SVAL5         IFEQ      '*NRF'                                                     CAAA02
     C                   MOVE      SVALK5        DBKEY                                        CAAA02
     C                   ENDIF                                                                CAAA02
     C     SVAL4         IFEQ      '*NRF'                                                     CAAA02
     C                   MOVE      SVALK4        DBKEY                                        CAAA02
     C                   ENDIF                                                                CAAA02
     C     SVAL3         IFEQ      '*NRF'                                                     CAAA02
     C                   MOVE      SVALK3        DBKEY                                        CAAA02
     C                   ENDIF                                                                CAAA02
     C     SVAL2         IFEQ      '*NRF'                                                     CAAA02
     C                   MOVE      SVALK2        DBKEY                                        CAAA02
     C                   ENDIF                                                                CAAA02
     C     SVAL1         IFEQ      '*NRF'                                                     CAAA02
     C                   MOVE      SVALK1        DBKEY                                        CAAA02
     C                   ENDIF                                                                CAAA02
                                                                                              CAAA02
     C     *LOCK         IN        LDA                                                        CAAA02
     C                   MOVEL     '009'         DBASE                                        CAAA02
     C                   MOVE      'SDSVALPD'    DBFILE                                       CAAA02
     C                   MOVE      'FC0065'      DBPGM                                        CAAA02
     C                   OUT       LDA                                                        CAAA02
     C                   EXSR      *PSSR                                                      CAAA02
     C                   ENDIF                                                                CAAA02
      **                                                                                      CAAA02
     C     *LIKE         DEFINE    D5RQSQ        SRQSQ
     C     *LIKE         DEFINE    D6PSTS        SPSTS
     C                   MOVEL     '*'           SPGMQ
     C                   CALL      'ZA0250'
     C                   SETON                                        60
     C                   EXSR      RTV
     C                   EXSR      SSUB
     C     INIT9         ENDSR
      *
      ********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R INSTR - ARRANGE INSTRUCTION FOR FOOTER
     C*  CALLED FROM SSUB
     C*
     C********************************************************************
      *
     C     INSTR         BEGSR
     C                   MOVEL     *BLANKS       SINSTR
     C*
      ** If user cannot change output instructions
     C*
     C     @AUT          IFEQ      'N'
     C                   MOVEL     INS(1)        SINSTR           70
     C                   END
     C*
      ** If enquire on today's report and
      ** user can change output instructions
     C*
     C     @RPTD         IFEQ      'T'
     C     @AUT          ANDEQ     'Y'
     C                   MOVEL     INS(2)        SINSTR
     C                   END
     C*
      ** If enquire on yesterday's report and
      ** user can change output instructions
     C*
     C     @RPTD         IFEQ      'Y'
     C     @AUT          ANDEQ     'Y'
     C                   MOVEL     INS(3)        SINSTR
     C                   END
     C     INSTR9        ENDSR
     C*
      ********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R PCHG  - VALIDATE SUBFILE
     C*  CALLED FROM MAIN
     C*  CALLS - VALA
     C*
     C********************************************************************
      *
     C     PCHG          BEGSR
      *
     C                   Z-ADD     1             RRN
     C                   CALL      'ZA0250'
      *
      ** Set on SFLNXTCHG
      *
     C                   SETON                                        25
     C                   SETOFF                                       75
      *
      ** DOWHILE changed records
      **  Validate screen selection
      **  Call 'QCMDEXC'
      **  Read changed records
      *
     C                   READC     FC0065S1                               83
      *
     C     *IN83         DOWEQ     '0'
      *
     C                   SETOFF                                       8940
      *
      ** Read subfile changed record
      ** DOWHILE F3 is not taken
      ** Validate screen input
      *
     C     SSEL          IFNE      *BLANK
     C                   EXSR      VALA
     C                   END
     C*
     C     *IN89         IFEQ      '1'
     C                   MOVE      '1'           *IN40
     C                   SETON                                        75
     C                   ELSE
     C                   MOVE      '0'           *IN40
     C                   END
     C*
     C     SSEL          IFEQ      *BLANK
     C                   SETOFF                                       25
     C                   ELSE
     C                   SETON                                        25
     C                   END
     C*
     C                   UPDATE    FC0065S1
     C                   READC     FC0065S1                               83
     C*
     C                   END
     C*
     C     PCHG9         ENDSR
      *
      ********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R PSEL  - PROCESS SELECTION
     C*
     C*  CALLED BY - MAIN
     C*  CALLS - VALDTL
     C***********DSPSFL***************************************************                    CAAA02
     C*          RLSSFL
     C*          UPD
     C********************************************************************
     C*                                                                ***
     C*
     C     PSEL          BEGSR
     C                   SETOFF                                       76
     C                   Z-ADD     1             RRN
     C                   READC     FC0065S1                               83
      *
      ** Read subfile changed record
      ** DOWHILE F3/F12  not taken
      *
     C     *IN83         DOWEQ     '0'
     C     *IN03         ANDEQ     '0'
     C     *IN12         ANDEQ     '0'
     C*
     C** (Indicators 30 and 31 not now used)                              LN0912
     C**********           SETOF                     3031                 LN0912
     C*
     C** If delete, protect
     C** screen from input
     C*
     C     SSEL          IFEQ      '4'
     C                   SETON                                        33
     C                   ELSE                                                                  LN091
     C                   SETOFF                                       33                       LN091
     C                   END
     C*
      ***If*Copy*is*selected,*do*not*display*output*queue****             LN0912
     C*
     C********** SSEL      IFEQ '3'                                       LN0912
     C**********           SETON                     31                   LN0912
     C**********           END                                            LN0912
     C*
      ***If*Change*is*selected,*allow*input*to*all*fields****             LN0912
     C*
     C********** SSEL      IFEQ '2'                                       LN0912
     C**********           SETOF                     3133                 LN0912
     C**********           END                                            LN0912
     C*
     C** IF VALIDATION IS REQUIRED, EXECUTE VALIDATION ROUTINE
     C*
     C     SSEL          IFEQ      '2'
     C     SSEL          OREQ      '3'
     C     SSEL          OREQ      '4'
     C                   EXSR      VALDTL
     C                   END
     C**********                                                                              CAAA02
     C***IF*DISPLAY OPTION SELECTED, DISPLAY SPOOL FILE                                       CAAA02
     C**********                                                                              CAAA02
     C*****SSEL*         IFEQ      '5'                                                        CAAA02
     C**********         EXSR      DSPSFL                                                     CAAA02
     C**********         END                                                                  CAAA02
     C*
     C** IF RELEASE OPTION SELECTED, DISPLAY SPOOL FILE
     C*
     C     SSEL          IFEQ      '6'
     C                   EXSR      RLSSFL
     C                   END
     C*
      ** IF NO ERROR HAS OCCURRED, UPDATE SUBFILE SELECT TO BLANK
     C*
     C     *IN80         IFEQ      '0'
     C                   MOVE      *BLANK        SSEL
     C                   SETOFF                                       25
     C*
     C***UPDATE*CURRENT*STATUS*OF*PRINT****                               LN0912
     C*
     C********** SSEL      IFEQ '6'                                       LN0912
     C**********           MOVEL'NO '     SHOLD                           LN0912
     C**********           END                                            LN0912
     C*
     C** OTHERWISE, SEND ERROR MESSAGE
     C*
     C                   ELSE
     C                   MOVE      'FIN'         @ESPL
     C                   MOVE      TXT(2)        @STATS
     C                   EXSR      UPD
     C                   SETON                                        2576
     C                   END
     C*
      ** UPDATE CURRENT SUBFILE RECORD, AND ACCESS NEXT
     C*
     C                   UPDATE    FC0065S1
     C                   READC     FC0065S1                               83
     C*
     C                   END
     C*
     C** At end of processing, output
     C** Subfile Screen
     C*
     C     *IN03         IFEQ      '0'
     C     *IN12         ANDEQ     '0'
     C*
     C     *IN76         IFEQ      '1'
     C                   CALL      'ZA0250'
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0037' MSGID   7                       LN1186
     C                   PARM      'RCF1037'     MSGID             7                           LN118
     C                   WRITE     FC0060C0
     C*                                                                   LN0366
     C                   ELSE                                                                  LN036
     C                   CALL      'ZA0250'                                                    LN036
     C                   WRITE     FC0060C0                                                    LN036
     C*                                                                   LN0366
     C                   END
     C*
     C                   WRITE     FC0065F1
     C                   WRITE     FC0065F2
     C                   EXFMT     FC0065C1
     C                   END
     C*
     C     PSEL9         ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R DSPSFL - DISPLAY SPOOL FILE ENTRY
     C*  CALLED FROM - PSEL
     C*
     C********************************************************************
     C***********                                                                           CAAA02
     C*****DSPSFL        BEGSR                                                              CAAA02
     C***********                                                                           CAAA02
     C***********        MOVE      *BLANK        CMDEXC                                     CAAA02
     C***********                                                                           CAAA02
     C***SET*UP*QCMDEXC DETAILS                                                             CAAA02
     C***********                                                                           CAAA02
     C***********        MOVEL     ARR(1)        CMD                                        CAAA02
     C***********        MOVEL     ARR(6)        FILJOB                                     CAAA02
     C***********        MOVEL     ARR(7)        SPLDTL                                     CAAA02
     C***********                                                                           CAAA02
     C***SET*UP*FILE & JOB NAMES FROM APPROPRIATE FILES                                     CAAA02
     C***********                                                                           CAAA02
     C***********        MOVE      SRSFX         RSFX                                       CAAA02
     C***********        MOVE      SSFNO         SFNO                                       CAAA02
     C***********        MOVE      @NUM          PJBNB                                      CAAA02
     C***********                                                                           CAAA02
     C***ADJUST*JOB NAME TO COMPRESS OUT SPACES                                             CAAA02
     C***********                                                                           CAAA02
     C***********        MOVEA     *BLANK        JOB                                        CAAA02
     C***********                                                                           CAAA02
     C***********        MOVEA     @USR          JOB                                        CAAA02
     C***********        Z-ADD     1             X                 2 0                      CAAA02
     C*****'*'***        LOOKUP    JOB(X)                                 70                CAAA02
     C***********        MOVE      '/'           JOB(X)                                     CAAA02
     C***********        ADD       1             X                                          CAAA02
     C***********        MOVEA     @JOB          JOB(X)                                     CAAA02
     C***********                                                                           CAAA02
     C***********        MOVEA     JOB           JBDTLS                                     CAAA02
     C***********                                                                           CAAA02
     C***CONCATENATE QCMDEXC STRING                                                         CAAA02
     C***********                                                                           CAAA02
     C***********        MOVE      FILJOB        FILDTL                                     CAAA02
     C***********        MOVE      SPLDTL        SFDETL                                     CAAA02
     C***********                                                                           CAAA02
     C***EXECUTE*COMMAND                                                                    CAAA02
     C***********                                                                           CAAA02
     C***********        CALL      'QCMDEXC'                            80                  CAAA02
     C***********        PARM                    CMDEXC                                     CAAA02
     C***********          PARM 175       LEN    155                      LN0912            CAAA02
     C***********        PARM      200           LEN              15 5                LN0912CAAA02
      ***********                                                                           CAAA02
     C***********        ENDSR                                                              CAAA02
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R DLTSFL - DELETE SPOOL FILE ENTRY
     C*  CALLED FROM - VALDTL
     C*
     C********************************************************************
     C*
     C     DLTSFL        BEGSR
     C*
     C                   MOVE      *BLANK        CMDEXC
     C*
     C** SET UP QCMDEXC DETAILS
     C*
     C                   MOVEL     ARR(3)        CMD
     C                   MOVEL     ARR(6)        FILJOB
     C                   MOVEL     ARR(7)        SPLDTL
     C*
     C** SET UP FILE & JOB NAMES FROM APPROPRIATE FILES
     C*
     C                   MOVE      SRSFX         RSFX
     C                   MOVE      SSFNO         SFNO
     C                   MOVE      @NUM          PJBNB
     C*
     C** ADJUST JOB NAME TO COMPRESS OUT SPACES
     C*
     C                   MOVEA     *BLANK        JOB
      *
     C                   MOVEA     @USR          JOB
     C                   Z-ADD     1             X                 2 0
     C     ' '           LOOKUP    JOB(X)                                 70
     C                   MOVE      '/'           JOB(X)
     C                   ADD       1             X
     C                   MOVEA     @JOB          JOB(X)
      *
     C                   MOVEA     JOB           JBDTLS
     C*
     C** CONCATENATE QCMDEXC STRING
     C*
     C                   MOVE      FILJOB        FILDTL
     C                   MOVE      SPLDTL        SFDETL
     C*
     C** EXECUTE COMMAND
     C*
     C                   CALL      'QCMDEXC'                            80
     C                   PARM                    CMDEXC
     C**********           PARM 175       LEN    155                      LN0912
     C                   PARM      200           LEN              15 5                         LN091
      *
     C**********           EXSR UPD                                       LN0912
      *
     C     *IN80         IFEQ      '0'
     C                   EXSR      UPD                                                         LN091
     C                   MOVEL     TXT(2)        @STATS
     C                   MOVE      'FIN'         @ESPL
     C                   MOVEL     'NO '         SSAVE
     C                   MOVEL     'NO '         SHOLD
     C                   MOVEL     *BLANKS       SCPYS
     C                   MOVEL     *BLANKS       POUTQ
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R RLSSFL - RELEASE SPOOL FILE ENTRY
     C***CALLED*FROM*-*PSEL****                                           LN0912
     C*  CALLED FROM - PSEL, CHGSFL                                       LN0912
     C*
     C********************************************************************
     C*
     C     RLSSFL        BEGSR
     C*
     C                   MOVE      *BLANK        CMDEXC
     C*
     C** SET UP QCMDEXC DETAILS
     C*
     C                   MOVEL     ARR(2)        CMD
     C                   MOVEL     ARR(6)        FILJOB
     C                   MOVEL     ARR(7)        SPLDTL
     C*
     C** SET UP FILE & JOB NAMES FROM APPROPRIATE FILES
     C*
     C                   MOVE      SRSFX         RSFX
     C                   MOVE      SSFNO         SFNO
     C                   MOVE      @NUM          PJBNB
     C*
     C** ADJUST JOB NAME TO COMPRESS OUT SPACES
     C*
     C                   MOVEA     *BLANK        JOB
      *
     C                   MOVEA     @USR          JOB
     C                   Z-ADD     1             X                 2 0
     C     ' '           LOOKUP    JOB(X)                                 70
     C                   MOVE      '/'           JOB(X)
     C                   ADD       1             X
     C                   MOVEA     @JOB          JOB(X)
      *
     C                   MOVEA     JOB           JBDTLS
     C*
     C** CONCATENATE QCMDEXC STRING
     C*
     C                   MOVE      FILJOB        FILDTL
     C                   MOVE      SPLDTL        SFDETL
     C*
     C** EXECUTE COMMAND
     C*
     C                   CALL      'QCMDEXC'                            80
     C                   PARM                    CMDEXC
     C**********           PARM 175       LEN    155                      LN0912
     C                   PARM      200           LEN              15 5                         LN091
      *
     C     *IN80         IFEQ      '0'
     C                   MOVEL     'NO '         SHOLD
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT                                                              LN0912
     C********************************************************************LN0912
     C*                                                                   LN0912
     C*  S/R HLDSFL - HOLD SPOOL FILE                                     LN0912
     C*  CALLED FROM - CHGSFL                                             LN0912
     C*                                                                   LN0912
     C********************************************************************LN0912
     C*                                                                   LN0912
     C     HLDSFL        BEGSR                                                                 LN091
     C*                                                                   LN0912
     C                   MOVE      *BLANK        CMDEXC                                        LN091
     C*                                                                   LN0912
     C** SET UP QCMDEXC DETAILS                                           LN0912
     C*                                                                   LN0912
     C                   MOVEL     ARR(11)       CMD                                           LN091
     C                   MOVEL     ARR(6)        FILJOB                                        LN091
     C                   MOVEL     ARR(7)        SPLDTL                                        LN091
     C*                                                                   LN0912
     C** SET UP FILE & JOB NAMES FROM APPROPRIATE FILES                   LN0912
     C*                                                                   LN0912
     C                   MOVE      SRSFX         RSFX                                          LN091
     C                   MOVE      SSFNO         SFNO                                          LN091
     C                   MOVE      @NUM          PJBNB                                         LN091
     C*                                                                   LN0912
     C** ADJUST JOB NAME TO COMPRESS OUT SPACES                           LN0912
     C*                                                                   LN0912
     C                   MOVEA     *BLANK        JOB                                           LN091
      *                                                                   LN0912
     C                   MOVEA     @USR          JOB                                           LN091
     C                   Z-ADD     1             X                 2 0                         LN091
     C     ' '           LOOKUP    JOB(X)                                 70                   LN091
     C                   MOVE      '/'           JOB(X)                                        LN091
     C                   ADD       1             X                                             LN091
     C                   MOVEA     @JOB          JOB(X)                                        LN091
      *                                                                   LN0912
     C                   MOVEA     JOB           JBDTLS                                        LN091
     C*                                                                   LN0912
     C** CONCATENATE QCMDEXC STRING                                       LN0912
     C*                                                                   LN0912
     C                   MOVE      FILJOB        FILDTL                                        LN091
     C                   MOVE      SPLDTL        SFDETL                                        LN091
     C*                                                                   LN0912
     C** EXECUTE COMMAND                                                  LN0912
     C*                                                                   LN0912
     C                   CALL      'QCMDEXC'                            80                     LN091
     C                   PARM                    CMDEXC                                        LN091
     C**********           PARM 175       LEN    155                      LN0912
     C                   PARM      200           LEN              15 5                         LN091
      *                                                                   LN0912
     C     *IN80         IFEQ      '0'                                                         LN091
     C                   MOVEL     'YES'         SHOLD                                         LN091
     C                   END                                                                   LN091
      *                                                                   LN0912
     C                   ENDSR                                                                 LN091
     C********************************************************************LN0912
      /EJECT
     C********************************************************************
     C*
     C***S/R*MOVSFL*-*MOVE*SPOOL*FILE*TO*A*DIFFERENT*OUTPUT*QUEUE****     LN0912
     C*  S/R CHGSFL - CHANGE ATTRIBUTES (OUTQ, COPIES, SAVE) FOR SPOOL    LN0912
     C*               FILE AND CALL HLDSFL/RLSSFL AS REQUIRED.            LN0912
     C*  CALLED FROM - VALDTL
     C*  CALLS - HLDSFL, RLSSFL                                           LN0912
     C*
     C********************************************************************
     C*
     C********** MOVSFL    BEGSR                                          LN0912
     C     CHGSFL        BEGSR                                                                 LN091
     C*
     C                   MOVE      *BLANK        CMDEXC
     C*
     C** SET UP QCMDEXC DETAILS
     C*
     C                   MOVEL     ARR(4)        CMD
     C                   MOVEL     ARR(6)        FILJOB
     C                   MOVEL     ARR(7)        SPLDTL
     C                   MOVEL     ARR(8)        OTQDTL
     C*
     C** SET UP FILE & JOB NAMES FROM APPROPRIATE FILES
     C*
     C                   MOVE      SRSFX         RSFX
     C                   MOVE      SSFNO         SFNO
     C                   MOVE      @NUM          PJBNB
     C*
     C** ADJUST JOB NAME TO COMPRESS OUT SPACES
     C*
     C                   MOVEA     *BLANK        JOB
      *
     C                   MOVEA     @USR          JOB
     C                   Z-ADD     1             X                 2 0
     C     ' '           LOOKUP    JOB(X)                                 70
     C                   MOVE      '/'           JOB(X)
     C                   ADD       1             X
     C                   MOVEA     @JOB          JOB(X)
      *
     C                   MOVEA     JOB           JBDTLS
     C*
     C** SET UP OUTPUT QUEUE NAME: AS ENTERED
     C*
     C********** SOUTQ     IFNE *BLANK                                    LN0912
     C                   MOVE      SOUTQ         TOOUTQ
     C**********           END                                            LN0912
     C*
     C***SET*UP*OUTPUT*QUEUE*NAME*FROM*USER*PROFILE****                   LN0912
     C*
     C********** SUSR      IFNE *BLANK                                    LN0912
     C**********           MOVE OUTQ      TOOUTQ                          LN0912
     C**********           END                                            LN0912
     C*
     C** CONCATENATE QCMDEXC STRING
     C*
     C                   MOVE      FILJOB        FILDTL
     C                   MOVE      SPLDTL        SFDETL
     C                   MOVE      OTQDTL        OUTQDT
     C*
     C** ADDITIONAL PARMS FOR CHGSPLFA - COPIES, SAVE.                    LN0912
     C                   MOVEL     ARR(10)       COPSAV                                        LN091
     C                   MOVE      CHCPYS        NUMCOP                                        LN091
     C     CHSAVE        IFEQ      'Y'                                                         LN091
     C                   MOVEL     'YES'         SAVEYN                                        LN091
     C                   ELSE                                                                  LN091
     C**********           MOVEL'NO'      SAVEYN                    LN0912LN1153
     C                   MOVEL     'NO '         SAVEYN                                        LN115
     C                   END                                                                   LN091
     C*                                                                   LN0912
     C** EXECUTE COMMAND
     C*
     C                   CALL      'QCMDEXC'                            80
     C                   PARM                    CMDEXC
     C**********           PARM 175       LEN    155                      LN0912
     C                   PARM      200           LEN              15 5                         LN091
      *
     C     *IN80         IFEQ      '0'                                                         LN091
     C*                                                                   LN0912
     C** SET UP NEW VALUES FOR SUBFILE DISPLAY                            LN0912
     C*                                                                   LN0912
     C                   MOVEL     *BLANKS       POUTQ                                         LN091
     C                   MOVEL     SOUTQ         POUTQ                                         LN091
     C*                                                                   LN0912
     C     CHSAVE        IFEQ      'Y'                                                         LN091
     C                   MOVEL     'YES'         SSAVE                                         LN091
     C                   ELSE                                                                  LN091
     C**********           MOVEL'NO'      SSAVE                     LN0912LN1153
     C                   MOVEL     'NO '         SSAVE                                         LN115
     C                   END                                                                   LN091
     C*                                                                   LN0912
     C                   MOVEL     CHCPYS        CPYS2A                                        LN091
     C     CPYS2         IFEQ      '0'                                                         LN091
     C                   MOVE      CPYS3         CPYS2                                         LN091
     C                   MOVE      *BLANK        CPYS3                                         LN091
     C                   END                                                                   LN091
     C                   MOVEL     CPYS5A        SCPYS                                         LN091
     C*                                                                   LN0912
     C                   END                                                                   LN091
     C*                                                                   LN0912
      ** IF USER CHANGED VALUE OF 'HOLD', CALL RLSSFL OR HLDSFL.          LN0912
      *                                                                   LN0912
     C     SVHOLD        IFEQ      'Y'                                                         LN091
     C     CHHOLD        ANDEQ     'N'                                                         LN091
     C                   EXSR      RLSSFL                                                      LN091
     C                   END                                                                   LN091
      *                                                                   LN0912
     C     SVHOLD        IFEQ      'N'                                                         LN091
     C     CHHOLD        ANDEQ     'Y'                                                         LN091
     C                   EXSR      HLDSFL                                                      LN091
     C                   END                                                                   LN091
      *                                                                   LN0912
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R CPYSFL - COPY SPOOL FILE USING SNDNETSPLF
     C*  CALLED FROM - VALDTL
     C*
     C********************************************************************
     C*
     C     CPYSFL        BEGSR
     C*
     C                   MOVE      *BLANK        CMDEXC
     C*
     C** SET UP QCMDEXC DETAILS
     C*
     C                   MOVEL     ARR(5)        CMD
     C                   MOVEL     ARR(6)        FILJOB
     C                   MOVEL     ARR(7)        SPLDTL
     C                   MOVEL     ARR(9)        DIRIDD
     C*
     C** SET UP FILE & JOB NAMES FROM APPROPRIATE FILES
     C*
     C                   MOVE      SRSFX         RSFX
     C                   MOVE      SSFNO         SFNO
     C                   MOVE      @NUM          PJBNB
     C*
     C** ADJUST JOB NAME TO COMPRESS OUT SPACES
     C*
     C                   MOVEA     *BLANK        JOB
      *
     C                   MOVEA     @USR          JOB
     C                   Z-ADD     1             X                 2 0
     C     ' '           LOOKUP    JOB(X)                                 70
     C                   MOVE      '/'           JOB(X)
     C                   ADD       1             X
     C                   MOVEA     @JOB          JOB(X)
      *
     C                   MOVEA     JOB           JBDTLS
     C*
     C** SET UP DIRECTORY DETAILS: FROM SCREEN
     C*
     C     SDIS1         IFNE      *BLANK
     C                   MOVE      SDIS1         DLS1
     C                   MOVE      SDIS2         DLS2
     C                   END
     C*
     C** SET UP DIRECTORY DETAILS FROM USER PROFILE
     C*
     C     SUSR          IFNE      *BLANK
     C                   MOVE      DIRID         DLS1
     C                   MOVE      DIRAD         DLS2
     C                   END
     C*
     C** CONCATENATE QCMDEXC STRING
     C*
     C                   MOVE      FILJOB        FILDTL
     C                   MOVE      SPLDTL        SFDETL
     C                   MOVE      DIRIDD        DIRDTL
     C*
     C** EXECUTE COMMAND
     C*
     C                   CALL      'QCMDEXC'                            80
     C                   PARM                    CMDEXC
     C**********           PARM 175       LEN    155                      LN0912
     C                   PARM      200           LEN              15 5                         LN091
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R VALDTL - PERFORM VALIDATION OF DETAIL SCREEN
     C*  CALLED FROM - PSEL
     C***CALLS*-*DLTSFL,*VALB,*CPYSFL,*MOVSFL****                         LN0912
     C*  CALLS - DLTSFL, VALB, CPYSFL, CHGSFL                             LN0912
     C*
     C********************************************************************
     C*
     C     VALDTL        BEGSR
     C*
     C** WRITE DETAIL SCREEN
     C*
     C                   SETOFF                                       75
     C                   SETOFF                                       4142                     LN066
     C     SSEL          IFEQ      '3'                                                         LN091
     C                   EXFMT     FC0065F3
     C                   ELSE                                                                  LN091
     C     SSEL          IFEQ      '2'                                                         LN091
     C*                                                                   LN0912
     C** SET UP FIELDS FOR 'CHANGE' SCREEN                                LN0912
     C*                                                                   LN0912
     C     SSAVE         IFEQ      'YES'                                                       LN091
     C                   MOVEL     'Y'           CHSAVE                                        LN091
     C                   ELSE                                                                  LN091
     C                   MOVEL     'N'           CHSAVE                                        LN091
     C                   END                                                                   LN091
     C     SHOLD         IFEQ      'YES'                                                       LN091
     C                   MOVEL     'Y'           CHHOLD                                        LN091
     C                   ELSE                                                                  LN091
     C                   MOVEL     'N'           CHHOLD                                        LN091
     C                   END                                                                   LN091
     C*                                                                   LN0912
     C                   MOVEL     SCPYS         CPYS5A                                        LN091
     C     CPYS3         IFEQ      *BLANK                                                      LN091
     C                   MOVE      CPYS2         CPYS3                                         LN091
     C                   MOVE      '0'           CPYS2                                         LN091
     C                   END                                                                   LN091
     C                   MOVE      CPYS2A        CHCPYS                                        LN091
     C*                                                                   LN0912
     C                   MOVEL     *BLANKS       SOUTQ                                         LN091
     C                   MOVEL     POUTQ         SOUTQ                                         LN091
     C*                                                                   LN0912
     C** SAVE INITIAL VALUE OF 'HOLD'                                     LN0912
     C                   MOVEL     CHHOLD        SVHOLD            1                           LN091
     C*                                                                   LN0912
     C                   END                                                                   LN091
     C*                                                                   LN0912
     C                   EXFMT     FC0065F4                                                    LN091
     C                   END                                                                   LN091
     C*
     C** PROCESS WHILE SCREEN INVALID/EXIT NOT REQUESTED
     C*
     C     *IN75         DOWEQ     '0'
     C     *IN03         ANDEQ     '0'
     C     *IN12         ANDEQ     '0'
     C*
      ** VALIDATE DETAILS
     C*
     C     SSEL          IFEQ      '4'
     C*
     C     *IN10         IFEQ      '1'
     C                   SETON                                        75
     C                   EXSR      DLTSFL
     C                   ELSE
     C                   SETON                                        89
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0021' MSGID                           LN1186
     C                   PARM      'RCF1021'     MSGID                                         LN118
     C                   END
     C*
     C                   ELSE
     C     SSEL          IFEQ      '3'                                                         LN091
     C                   EXSR      VALB
     C                   ELSE                                                                  LN091
     C                   EXSR      VALB2                                                       LN091
     C                   END                                                                   LN091
     C                   END
     C*
      ** IF SCREEN INVALID, DISPLAY MESSAGES
     C*
     C     *IN89         IFEQ      '1'
     C                   WRITE     FC0060C0
     C     SSEL          IFEQ      '3'                                                         LN091
     C                   EXFMT     FC0065F3
     C                   ELSE                                                                  LN091
     C                   EXFMT     FC0065F4                                                    LN091
     C                   END                                                                   LN091
     C                   ELSE
     C*
      ** OTHERWISE EXIT LOOP
     C*
     C                   SETON                                        75
     C                   END
     C*
     C                   END
     C*
     C** EXECUTE REQUIRED ACTION IF NO EXIT REQUESTED
     C*
     C     *IN03         IFEQ      '0'
     C     *IN12         ANDEQ     '0'
     C     SSEL          ANDNE     '4'
     C*
     C** IF COPY REQUIRED, PERFORM COPY PROCESSING
     C*
     C     SSEL          IFEQ      '3'
     C********** SSEL      OREQ '2'                                       LN0912
     C********** SOUTQ     ANDEQ*BLANK                                    LN0912
     C********** SUSR      ANDEQ*BLANK                                    LN0912
     C                   EXSR      CPYSFL
     C                   END
     C*
     C** IF CHANGE REQUIRED, PERFORM CHANGE PROCESSING
     C*
     C     SSEL          IFEQ      '2'
     C********** SUSR      ANDNE*BLANK                                    LN0912
     C********** SOUTQ     ORNE *BLANK                                    LN0912
     C**********           EXSR MOVSFL                                    LN0912
     C                   EXSR      CHGSFL                                                      LN091
     C                   END
     C*
     C                   END
     C*
     C     SSEL          IFEQ      '3'                                                         LN091
     C**********           MOVE *BLANK    SOUTQ                           LN0912
     C                   MOVE      *BLANK        SUSR
     C                   MOVE      *BLANK        SDIS1
     C                   MOVE      *BLANK        SDIS2
     C                   END                                                                   LN091
     C*
     C                   SETOFF                                       12
     C*
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R *PSSR - ERROR ROUTINE
     C*  CALLED FROM
     C*
     C********************************************************************
     C*
     C     *PSSR         BEGSR
     C*
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
     C*
     C                   MOVE      'T'           @RTERM
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R RTV   - RETRIEVE DETAILS FROM DB FILES
     C*  CALLED FROM INIT
     C*
     C********************************************************************
      *
     C     RTV           BEGSR
     C*
     C** Set up key list for Report Req.file
     C*
     C     @RREQ         KLIST
     C                   KFLD                    @RNAM
     C                   KFLD                    @RQSQ
     C*
     C** Set up key list for Spool file Number(TODAY)
     C*
     C     @RSFL         KLIST
     C                   KFLD                    @RQSQ
     C*
     C     @SFNO         KLIST
     C                   KFLD                    @RQSQ
     C                   KFLD                    KSFX
     C                   KFLD                    KETTY
     C                   KFLD                    KSFNO                                         14279
     C*
      ** If Today's report is requested,
      ** set pointer to read FCRREQL1
     C*
     C     @RPTD         IFEQ      'T'
     C                   SETON                                        51
     C     @RREQ         CHAIN     FCRREQL1                           71
     C*
      ** If Yesterday's report is requested,
      ** set pointer to read FCYREQL1
     C*
     C                   ELSE
     C                   SETOFF                                       51
     C     @RREQ         CHAIN     FCYREQL1                           71
     C                   END
      *
     C     *IN71         IFEQ      '0'
     C*
      * If Today's report is requested,
     C*
     C     @RPTD         IFEQ      'T'
     C                   MOVEL     D5RQSQ        SRQSQ
     C                   MOVEL     D5LVL         SLVL
     C                   MOVEL     D5ETTY        SETTY
     C                   MOVEL     D5USRR        SUSRR
     C                   MOVEL     D5USRO        SUSR
     C                   MOVEL     D5DRQD        SDRQD
     C                   MOVEL     D5JBNM        @JOB
     C                   MOVEL     D5JUSR        @USR
     C                   MOVEL     D5JBNB        @NUM
     C*
     C                   ELSE
      * If Yesterday's report is requested,
     C                   MOVEL     EKRQSQ        SRQSQ
     C                   MOVEL     EKLVL         SLVL
     C                   MOVEL     EKETTY        SETTY
     C                   MOVEL     EKUSRR        SUSRR
     C                   MOVEL     EKUSRO        SUSR
     C                   MOVEL     EKDRQD        SDRQD
     C                   MOVEL     EKJBNM        @JOB
     C                   MOVEL     EKJUSR        @USR
     C                   MOVEL     EKJBNB        @NUM
     C                   END
     C*
      ** Display first format
     C*
     C***********          WRITEFC0065F1                                  LN0851
     C                   END
     C*
      ** If record not found, perform
      ** standard routine for DB error
     C*
     C     *IN71         IFEQ      '1'
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C     @RPTD         IFEQ      'T'
     C                   MOVEL     'FCRREQPD'    DBFILE
     C                   ELSE
     C                   MOVEL     'FCYREQPD'    DBFILE
     C                   END
     C                   MOVEL     REQKDS        DBKEY                          ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   OUT       LDA                                          ***************
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   END
     C*
     C                   ENDSR
      ********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R SSUB  - Set up subfiles to display spool
     C*              file attributes
     C*  CALLED FROM INIT
     C*  CALLS - INSTR
     C*
     C********************************************************************
      *
     C     SSUB          BEGSR
      *
      ** Clear subfile and write
      ** subfile control record
      *
     C                   CALL      'ZA0250'
     C                   SETON                                        23
     C                   SETOFF                                       2021
     C                   WRITE     FC0065C1
     C                   SETOFF                                       23
     C                   SETON                                        2021
     C                   Z-ADD     1             RRN               3 0
     C*
      ** If Today's report is requested,
      ** set pointer to read FCSFNOL1
     C*
     C     @RPTD         IFEQ      'T'
     C     @RSFL         SETLL     FCSFNOL1
     C     @RSFL         READE     FCSFNOL1                               22
     C                   END
     C*
      ** If Yesterday's report is requested,
      ** set pointer to read FCYFNOL1
     C*
     C     @RPTD         IFEQ      'Y'
     C     @RSFL         SETLL     FCYFNOL1
     C     @RSFL         READE     FCYFNOL1                               22
     C                   END
     C*
     C     *IN22         IFEQ      '1'
     C                   SETOFF                                       20
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0069' MSGID                           LN1186
     C                   PARM      'RCF1069'     MSGID                                         LN118
     C                   END
     C*
      ** Load subfiles
      ** DO while not end of file
     C*
     C     *IN22         DOWEQ     '0'
     C*
     C** If request for today's report
     C*
     C     @RPTD         IFEQ      'T'
     C**********           MOVELD6SFNO    SSFNO                           LN0852
     C                   MOVEL     D6SFNO        SSFNO             4                           LN085
     C                   MOVEL     D6RSFX        SRSFX
     C                   MOVEL     D6PSTS        SPSTS
     C                   MOVEL     D6XETY        SXETY
     C**********           MOVELD6SFNO    SSFNO                           LN0852
     C*
     C** IF request for yesterday's report
     C*
     C                   ELSE
     C                   MOVEL     ELSFNO        SSFNO
     C                   MOVEL     ELRSFX        SRSFX
     C                   MOVEL     ELPSTS        SPSTS
     C                   MOVEL     ELXETY        SXETY
     C**********           MOVELELSFNO    SSFNO                           LN0852
     C                   END
     C*
     C** Access spool file text from report suffixes file
     C*
     C                   CALL      'AORSFXR0'
     C                   PARM      '*DBERR'      P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM                    @RNAM                            I:Report Name
     C                   PARM                    SRSFX                            I:Spool File
     C     P@RSFX        PARM      P@RSFX        DSFDY                            O:Rec format
     C*
     C                   MOVE      DYPFTX        SSFTX
     C*
     C** Set up the status of the spool file for the screen               LN1142
     C*                                                                   LN1142
     C     SPSTS         IFEQ      'N'
     C     SPSTS         OREQ      'F'                                                         04370
     C***********DYAURP    ANDEQ'N'                                 LN1142043702
     C     DYAURP        IFEQ      'N'                                                         04370
     C***********          MOVELTXT,1     @STATS 22                       LN1142
     C                   MOVEL     TXT(1)        @STATS           23                           LN114
     C                   END                                                                   04370
     C                   END
     C*
     C     SPSTS         IFEQ      'N'                                                         LN114
     C     SPSTS         OREQ      'F'                                                         04370
     C***********DYAURP    ANDEQ'Y'                                 LN1142043702
     C     DYAURP        IFEQ      'Y'                                                         04370
     C                   MOVEL     TXT(4)        @STATS                                        LN114
     C                   END                                                                   04370
     C                   END                                                                   LN114
     C*                                                                   LN1142
     C     SPSTS         IFEQ      'P'
     C                   MOVEL     TXT(2)        @STATS
     C                   MOVE      'FIN'         @ESPL                                         LN091
     C                   END
     C*
     C     SPSTS         IFEQ      'D'
     C                   MOVEL     TXT(3)        @STATS
     C                   END
      *
     C                   MOVE      *BLANK        @ESPL
      *
     C                   CALL      'FCC0260'
     C                   PARM                    SRSFX
     C                   PARM                    @NUM
     C                   PARM                    @USR
     C                   PARM                    @JOB
     C                   PARM                    SSFNO
     C                   PARM                    @RQSQ                                         LN085
     C                   PARM      *BLANK        @HOLD             1
     C                   PARM      *BLANK        @SAVE             1
     C                   PARM      *BLANK        @CPYS             4
     C                   PARM      *BLANK        POUTQ            10                           LN085
     C                   PARM      *BLANK        @ERR              1
     C*
     C********** @ERR      IFEQ 'Y'                                       LN0851
     C     @ERR          IFEQ      'P'                                                         LN085
     C                   MOVEL     TXT(2)        @STATS
     C                   MOVE      'FIN'         @ESPL
     C                   END
     C*
     C     @ERR          IFEQ      'Y'                                                         LN085
     C     *LOCK         IN        LDA                                                         LN085
     C                   MOVEL     'FCC0260'     DBFILE                                        LN085
     C                   MOVEL     SRSFX         DBKEY                          ***************LN085
     C                   Z-ADD     2             DBASE                          * DB ERROR 02 *LN085
     C                   OUT       LDA                                          ***************LN085
     C                   SETON                                        U7U8LR                   LN085
     C                   EXSR      *PSSR                                                       LN085
     C                   END                                                                   LN085
     C*                                                                   LN0851
     C                   MOVE      @CPYS         SCPYS
     C*
     C     @HOLD         IFEQ      'Y'
     C                   MOVEL     'YES'         SHOLD
     C                   ELSE
     C                   MOVEL     'NO '         SHOLD
     C                   END
     C*
     C     @SAVE         IFEQ      'Y'
     C                   MOVEL     'YES'         SSAVE
     C                   ELSE
     C                   MOVEL     'NO '         SSAVE
     C                   END
      **                                                                                      CAAA02
      ** Create the job substring                                                             CAAA02
     C                   EVAL      JobStr = @NUM + '%2f' + %TRIMR(@USR) +                     CAAA02
     C                                     '%2f' + %TRIM(@JOB)                                CAAA02
      **                                                                                      CAAA02
      ** Create the File name string                                                          CAAA02
     C                   EVAL      FilStr = '&fileName=' + SRSFX                              CAAA02
      **                                                                                      CAAA02
      ** Create the Spool Number String                                                       CAAA02
     C                   EVAL      SplNbr = '&fileNumber=' + SSFNO                            CAAA02
      **                                                                                      CAAA02
      * Hidden field for SpoolViewer                                                          CAAA02
     C                   EVAL      JobInfo1 = 'http://' + %TRIMR(SVAL1)                       CAAA02
     C                   EVAL      SPLLNK   = %TRIM(JobInfo1) + JobSPL +                      CAAA02
     C                                        %TRIM(JobStr) +                                 CAAA02
     C                                        %TRIM(FilStr) +                                 CAAA02
     C                                        %TRIM(SplNbr)                                   CAAA02
      *                                                                                       CAAA02
      * Hidden field for viewing as a PDF Document                                            CAAA02
     C                   EVAL      PDFLNK   = %TRIM(JobInfo1) + JobPDF +                      CAAA02
     C                                        %TRIM(JobStr) +                                 CAAA02
     C                                        %TRIM(FilStr) +                                 CAAA02
     C                                        %TRIM(SplNbr)                                   CAAA02
      *                                                                                       CAAA02
      * Hidden field for viewing as a PCL Document                                            CAAA02
     C                   EVAL      PCLLNK   = %TRIM(JobInfo1) + JobPCL +                      CAAA02
     C                                        %TRIM(JobStr) +                                 CAAA02
     C                                        %TRIM(FilStr) +                                 CAAA02
     C                                        %TRIM(SplNbr)                                   CAAA02
      *                                                                                       CAAA02
     C                   WRITE     FC0065S1
     C                   ADD       1             RRN
     C     @RPTD         IFEQ      'T'
     C     @RSFL         READE     FCSFNOL1                               22
     C                   ELSE
     C     @RSFL         READE     FCYFNOL1                               22
     C                   END
     C*
     C                   END
     C*
     C** Write Footer
     C*
     C                   EXSR      INSTR
     C*
     C                   WRITE     FC0065F1                                                    LN085
     C                   WRITE     FC0060C0                                                    LN066
     C                   WRITE     FC0065F2
     C                   EXFMT     FC0065C1
     C*
     C     SSUB9         ENDSR
      ********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R UPD -  UPDATE CHANGES TO DB FILE:FCSFNOL0
     C*  CALLED FROM DLTSFL, PSEL
     C*
     C********************************************************************
      *
     C     UPD           BEGSR
      *
     C     *LIKE         DEFINE    D6RSFX        KSFX
     C     *LIKE         DEFINE    D6XETY        KETTY
     C     *LIKE         DEFINE    D6SFNO        KSFNO                                         14279
      *
     C** Set up key list to CHAIN FCYFNOL0
      *
     C                   MOVEL     SRSFX         KSFX
     C                   MOVEL     SXETY         KETTY
     C                   MOVEL     SSFNO         KSFNO                                         14279
     C*
      ** UPDATE TODAY'S/YESTERDAY'S SPOOL FILE NUMBERS
     C*
     C     @RPTD         IFEQ      'T'
     C     @SFNO         CHAIN     FCSFNOL0                           71
     C                   ELSE
     C     @SFNO         CHAIN     FCYFNOL0                           71
     C                   END
     C*
     C     *IN71         IFEQ      '0'
     C                   MOVE      'P'           ELPSTS
     C*
     C     @RPTD         IFEQ      'T'
     C                   UPDATE    @D6REJB
     C                   ELSE
     C                   UPDATE    @ELREKI
     C                   END
     C*
     C                   END
     C*
     C     UPD9          ENDSR
      ********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R VALA  - To validate subfile selection
     C*  CALLED FROM PCHG
     C*
     C********************************************************************
      *
     C     VALA          BEGSR
      *
     C                   CALL      'ZA0250'
     C*
      ** IF FILE HAS PRINTED, SEND ERROR AND EXIT
     C*
     C     @ESPL         IFEQ      'FIN'
     C                   SETON                                        89
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0037' MSGID                           LN1186
     C                   PARM      'RCF1037'     MSGID                                         LN118
     C                   GOTO      VALA9
     C                   END
     C*
     C** Entry may only be '5'
     C** if user cannot change output instr.
     C*
     C     @AUT          IFEQ      'N'
     C     SSEL          ANDNE     '5'
     C                   SETON                                        89
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0032' MSGID                           LN1186
     C**********           PARM 'RCF1032' MSGID                     LN1186LN1153
     C                   PARM      'RCF1033'     MSGID                                         LN115
     C                   END
     C*
     C** Entry may be '3' or '5'
     C** if user can change output
     C** and this is today's enquiry
     C*
     C     @AUT          IFEQ      'Y'
     C     @RPTD         ANDEQ     'T'
     C     SSEL          IFNE      '3'
     C     SSEL          ANDNE     '5'
     C                   SETON                                        89
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0034' MSGID                           LN1186
     C                   PARM      'RCF1034'     MSGID                                         LN118
     C                   END
     C                   END
     C*
     C** ENTRY MUST BE BETWEEN 2 AND 6 OF AUTH TO DO EVERYTHING
     C*
     C     @AUT          IFEQ      'Y'
     C     @RPTD         ANDEQ     'Y'
     C     SSEL          ANDLT     '2'
     C     @AUT          OREQ      'Y'                                                         LN115
     C     @RPTD         ANDEQ     'Y'                                                         LN115
     C     SSEL          ANDGT     '6'                                                         LN115
     C********** SSEL      ORGT '6'                                       LN1153
     C                   SETON                                        89
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0035' MSGID                           LN1186
     C                   PARM      'RCF1035'     MSGID                                         LN118
     C                   END
     C*
     C** IF SPOOL FILE NOT HELD, CANNOT BE RELEASED
     C*
     C     @AUT          IFEQ      'Y'                                                         LN115
     C     @RPTD         ANDEQ     'Y'                                                         LN115
     C     SSEL          IFEQ      '6'
     C     SHOLD         ANDEQ     'NO '
     C                   SETON                                        89
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0045' MSGID                           LN1186
     C                   PARM      'RCF1045'     MSGID                                         LN118
     C                   END
     C                   END                                                                   LN115
     C*
     C     VALA9         ENDSR
     C*
      ********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R VALB  - To validate Screen format 3 when
     C***************selection*is*2,*3*or*4**********                     LN0912
     C*              selection is 3 (copy spool file).                    LN0912
     C*  CALLED FROM - VALDTL
     C*  CALLS       -
     C*
     C********************************************************************
      *
     C     VALB          BEGSR
      *
      ***Validation*for*change*and*copy*is*identical****                  LN0912
     C***Option*2*=*change*spool*file******                               LN0912
     C***Option*3*=*copy*spool*file********                               LN0912
     C*
     C                   SETOFF                                       89
     C**********           SETOF                     414243               LN0912
     C                   SETOFF                                       4142                     LN091
     C                   CALL      'ZA0250'
      *
      ** If user is entered, must be a valid
      ***user*with*an*output*Q****                                        LN0912
      ** user with a Directory ID                                         LN0912
      *
     C     SUSR          IFNE      JUSR
     C     SUSR          ANDNE     *BLANK
     C********** @MUSER    ANDEQ'Y'                                       LN0912
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM                    SUSR                             I:User profile
     C***********P@USER    PARM P@USER    DSFDY              O:Rec format 087380
     C     P@USER        PARM      P@USER        DSSDY                            O:Rec format 08738
      *
     C     P@APRC        IFNE      *BLANKS
     C                   SETON                                        8941
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0006' MSGID                           LN1186
     C                   PARM      'RCF1006'     MSGID                                         LN118
     C                   ELSE
      *
      ***FOR*CHANGE*OF*PRINT,*USER*MUST*HAVE*OUTPUT*QUEUE****             LN0912
      *
     C********** OUTQ      IFEQ *BLANK                                    LN0912
     C********** SSEL      ANDEQ'2'                                       LN0912
     C**********           SETON                     8941                 LN0912
     C**********           CALL 'FCC0240'                                 LN0912
     C**********           PARM 'RCF0007' MSGID                           LN0912
     C**********           END                                            LN0912
     C*
     C********** OUTQ      IFNE *BLANK                                    LN0912
     C**********           CALL 'FCC0520'                                 LN0912
     C**********           PARM           SOUTQ                           LN0912
     C**********           PARM           RTCD    7                       LN0912
     C*
     C********** RTCD      IFNE *BLANK                                    LN0912
     C**********           SETON                     8941                 LN0912
     C**********           CALL 'FCC0240'                                 LN0912
     C**********           PARM 'RCF0007' MSGID                           LN0912
     C**********           END                                            LN0912
     C*
     C**********           END                                            LN0912
      *
      ** FOR COPY OF PRINT, USER MUST HAVE DIRECTORY DETAILS
      *
     C     DIRID         IFEQ      *BLANK
     C     DIRAD         OREQ      *BLANK                                                      LN091
     C********** SSEL      ANDEQ'3'                                       LN0912
     C                   SETON                                        8941
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0038' MSGID                           LN1186
     C                   PARM      'RCF1038'     MSGID                                         LN118
     C                   END
      *
     C                   END
      *
     C                   END
     C*
      ***If*change*is*selected,*the************                           LN0912
      ***output*queue*name*must*be*valid*******                           LN0912
     C*
     C********** SOUTQ     IFNE *BLANKS                                   LN0912
     C**********           CALL 'FCC0520'                                 LN0912
     C**********           PARM           SOUTQ                           LN0912
     C**********           PARM           RTCD    7                       LN0912
     C*
     C********** RTCD      IFNE *BLANK                                    LN0912
     C**********           SETON                     8943                 LN0912
     C**********           CALL 'FCC0240'                                 LN0912
     C**********           PARM 'RCF0039' MSGID                           LN0912
     C**********           END                                            LN0912
     C*
     C**********           END                                            LN0912
      *
      ** ONE LOCATION MUST BE ENTERED
      *
     C********** SOUTQ     IFEQ *BLANK                                    LN0912
     C********** SUSR      ANDEQ*BLANK                                    LN0912
     C     SUSR          IFEQ      *BLANK                                                      LN091
     C     SDIS1         ANDEQ     *BLANK
     C     SDIS2         ANDEQ     *BLANK
     C                   SETON                                        894142
     C**********           SETON                     43                   LN0912
     C                   CALL      'FCC0240'
     C**********           PARM 'RCF0040' MSGID                           LN0912
     C***********          PARM 'RCF0075' MSGID                   LN0912  LN1186
     C                   PARM      'RCF1075'     MSGID                                         LN118
     C                   END
     C*
      ***If*not*authorise*to*access*other*users'*output****
      ***user-id-for-input*should*equal*to*current*user****
     C*
     C********** @MUSER    IFEQ 'N'
     C********** SUSR      ANDNE@USER
     C********** SUSR      ANDNE*BLANK
     C**********           SETON                     8941
     C**********           CALL 'FCC0240'
     C**********           PARM 'RCF0005' MSGID
     C**********           END
     C*
      ** either both distribution lists are blank
      ** or neither can be blank
     C*
     C     SDIS1         IFEQ      *BLANKS
     C     SDIS2         ANDNE     *BLANKS
     C     SDIS1         ORNE      *BLANKS
     C     SDIS2         ANDEQ     *BLANKS
     C                   SETON                                        8942
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0003' MSGID                           LN1186
     C                   PARM      'RCF1003'     MSGID                                         LN118
     C                   END
     C*
      ***If*output*Q*is*entered*****                                      LN0912
      ***neither*'user*for*output**or*distribution*****                   LN0912
      ***list*can*be*entered********                                      LN0912
      ** Cannot enter both 'User for output' and Distribution List        LN0912
     C*
     C********** SOUTQ     IFNE *BLANKS                                   LN0912
     C********** SUSR      ANDNE*BLANKS                                   LN0912
     C*
     C********** SOUTQ     ORNE *BLANKS                                   LN0912
     C********** SDIS1     ANDNE*BLANKS                                   LN0912
     C********** SOUTQ     ORNE *BLANKS                                   LN0912
     C********** SDIS2     ANDNE*BLANKS                                   LN0912
     C*
     C********** SUSR      ORNE *BLANKS                                   LN0912
     C     SUSR          IFNE      *BLANKS                                                     LN091
     C     SDIS1         ANDNE     *BLANKS
     C     SUSR          ORNE      *BLANKS
     C     SDIS2         ANDNE     *BLANKS
     C                   SETON                                        89
     C**********           SETON                     414243               LN0912
     C                   SETON                                        4142                     LN091
     C                   CALL      'FCC0240'
     C**********           PARM 'RCF0041' MSGID                           LN0912
     C***********          PARM 'RCF0075' MSGID                   LN0912  LN1186
     C                   PARM      'RCF1075'     MSGID                                         LN118
     C                   END
      *
     C     VALB9         ENDSR
      *
      ********************************************************************
      /EJECT                                                              LN0912
     C********************************************************************LN0912
     C*                                                                   LN0912
     C*  S/R VALB2 - To validate Screen format 4 when                     LN0912
     C*              selection is 2 (change spool file).                  LN0912
     C*  CALLED FROM - VALDTL                                             LN0912
     C*  CALLS       -                                                    LN0912
     C*                                                                   LN0912
     C********************************************************************LN0912
      *                                                                   LN0912
     C     VALB2         BEGSR                                                                 LN091
      *                                                                   LN0912
     C                   SETOFF                                       894344                   LN091
     C                   SETOFF                                       4546                     LN091
     C                   CALL      'ZA0250'                                                    LN091
      *                                                                   LN0912
      * Validate 'Save'                                                   LN0912
      * Entry required.                                                   LN0912
     C     CHSAVE        IFEQ      *BLANK                                       IF             LN091
     C                   SETON                                        8944      *              LN091
      * Send message 'Value required'                                     LN0912
     C                   CALL      'FCC0240'                                                   LN091
     C***********          PARM 'RCF0074' MSGID                   LN0912  LN1186
     C                   PARM      'RCF1074'     MSGID                                         LN118
     C                   ELSE                                                                  LN091
      * '?' processing                                                    LN0912
     C                   MOVEL     CHSAVE        W0NSRQ            1            Save After PrinLN091
     C     W0NSRQ        IFEQ      '?'                                          Search requiredLN091
     C                   CALL      'FCVLLSR'                                                   LN091
     C                   PARM                    W0RTN             7            Return code    LN091
     C                   PARM      1100255       Y2LSNO            7 0          List number.   LN091
     C     CHSAVE        PARM      CHSAVE        W0EXVL           20            Save After PrinLN091
      *                                                                   LN0912
      ** SET ON *IN89 TO CAUSE REDISPLAY OF SCREEN (DEFER CONFIRM)        LN0912
      *                                                                   LN0912
     C                   SETON                                        89                       LN091
     C                   END                                                                   LN091
     C*                                                                   LN0912
     C** CHECK FOR VALID VALUES                                           LN0912
     C*                                                                   LN0912
     C     CHSAVE        IFNE      'Y'                                                         LN091
     C     CHSAVE        ANDNE     'N'                                                         LN091
     C                   SETON                                        8944                     LN091
     C                   CALL      'FCC0240'                                                   LN091
     C                   PARM      'RCF0102'     MSGID                                         LN091
     C                   END                                                                   LN091
     C                   END                                                    FI             LN091
     C*                                                                   LN0912
      * Validate 'Hold'                                                   LN0912
      * Entry required.                                                   LN0912
     C     CHHOLD        IFEQ      *BLANK                                       IF             LN091
     C                   SETON                                        8945      *              LN091
      * Send message 'Value required'                                     LN0912
     C                   CALL      'FCC0240'                                                   LN091
     C***********          PARM 'RCF0074' MSGID                   LN0912  LN1186
     C                   PARM      'RCF1074'     MSGID                                         LN118
     C                   ELSE                                                                  LN091
      * '?' processing                                                    LN0912
     C                   MOVEL     CHHOLD        W0NSRQ            1            Hold Before PriLN091
     C     W0NSRQ        IFEQ      '?'                                          Search requiredLN091
     C                   CALL      'FCVLLSR'                                                   LN091
     C                   PARM                    W0RTN             7            Return code    LN091
     C                   PARM      1100251       Y2LSNO            7 0          List number.   LN091
     C     CHHOLD        PARM      CHHOLD        W0EXVL           20            Hold Before PriLN091
      *                                                                   LN0912
      ** SET ON *IN89 TO CAUSE REDISPLAY OF SCREEN (DEFER CONFIRM)        LN0912
      *                                                                   LN0912
     C                   SETON                                        89                       LN091
     C                   END                                                                   LN091
     C*                                                                   LN0912
     C** CHECK FOR VALID VALUES                                           LN0912
     C*                                                                   LN0912
     C     CHHOLD        IFNE      'Y'                                                         LN091
     C     CHHOLD        ANDNE     'N'                                                         LN091
     C                   SETON                                        8945                     LN091
     C                   CALL      'FCC0240'                                                   LN091
     C                   PARM      'RCF0101'     MSGID                                         LN091
     C                   END                                                                   LN091
     C                   END                                                    FI             LN091
      *                                                                   LN0912
      ** Check that no. of copies is numeric.                             LN0912
      ** If first character is blank, replace with zero.                  LN0912
      *                                                                   LN0912
     C                   MOVEL     CHCPYS        CHCPY1            1                           LN091
     C     CHCPY1        IFEQ      *BLANK                                                      LN091
     C                   MOVEL     '0'           CHCPYS                                        LN091
     C                   END                                                                   LN091
     C*                                                                   LN0912
     C                   CALL      'ZALIGN'                                                    LN091
     C                   PARM      *BLANK        W0RTN             7                           LN091
     C                   PARM      CHCPYS        UPARM2           16                           LN091
     C                   PARM      *ZERO         UPARM3            1 0                         LN091
     C                   PARM      2             UPARM4            2 0                         LN091
     C                   PARM      *BLANK        UPARM5           16                           LN091
     C*                                                                   LN0912
     C** IF ERROR, SEND MESSAGE 'NUMBER OF COPIES MUST BE NUMERIC'.       LN0912
     C*                                                                   LN0912
     C     W0RTN         IFEQ      '*ERROR*'                                                   LN091
     C                   SETON                                        8946      *              LN091
     C                   CALL      'FCC0240'                                                   LN091
     C***********          PARM 'RCF0103' MSGID                  LN0912   LN1186
     C                   PARM      'RCF0053'     MSGID                          Message id.    LN118
     C                   END                                                                   LN091
      *                                                                   LN0912
      ** If no. of copies is blank                                        LN0912
      *                                                                   LN0912
     C     CHCPYS        IFEQ      *BLANK                                       *IF            LN091
     C     CHCPYS        ORLT      '01'                                                        LN091
     C                   SETON                                        8946                     LN091
     C                   CALL      'FCC0240'                                                   LN091
     C***********          PARM 'RCF0104' MSGID                  LN0912   LN1186
     C                   PARM      'RCF0069'     MSGID                                         LN118
     C                   END                                                    *FI            LN091
      *                                                                   LN0912
      ** Output Queue Name required.                                      LN0912
      *                                                                   LN0912
     C     SOUTQ         IFEQ      *BLANK                                       *IF            LN091
     C                   SETON                                        8943      *              LN091
      * Send message 'Value required'                                     LN0912
     C                   CALL      'FCC0240'                                                   LN091
     C***********          PARM 'RCF0074' MSGID                   LN0912  LN1186
     C                   PARM      'RCF1074'     MSGID                                         LN118
     C                   ELSE                                                                  LN091
      *                                                                   LN0912
      * If Output Queue is not blank, check that it exists.               LN0912
      *                                                                   LN0912
     C                   CALL      'FCC0520'                                    Check Output QuLN091
     C                   PARM                    SOUTQ                          Output Queue   LN091
     C                   PARM      *BLANK        W0RTN                          *Return code   LN091
      *                                                                   LN0912
      ** If Return code is *Record does not exist                         LN0912
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF            LN091
     C                   SETON                                        8943      *              LN091
      * Send message 'out. queue does not exist'                          LN0912
     C                   CALL      'FCC0240'                                                   LN091
     C***********          PARM 'RCF0039' MSGID                   LN0912  LN1186
     C                   PARM      'RCF1039'     MSGID                          Message id.    LN118
      *                                                                   LN0912
     C                   END                                                    *FI            LN091
     C                   END                                                    *FI            LN091
      *                                                                   LN0912
     C                   ENDSR                                                  *FI            LN091
      /EJECT
      ********************************************************************
** CPY@
(c) Finastra International Limited 2001
** INS - Instructions used by format:FC0065F2
                                                                                              CAAA02
3=Copy                                                                                        CAAA02
2=Change   3=Copy   4=Delete   6=Release                                                      CAAA02
** TXT - describes status of spool file
Awaiting distribution
Already printed
Available
Available on Audit Outq                                                   LN1142
**  ARR - PROCESS SPOOL FILE
DSPSPLF
RLSSPLF
DLTSPLF
CHGSPLFA
SNDNETSPLF
FILE(          ) JOB(      /
) SPLNBR(      )
OUTQ(          )
TOUSRID(('        ' '        '))
COPIES(  ) SAVE(*   )                                                     LN0912
HLDSPLF                                                                   LN0912
