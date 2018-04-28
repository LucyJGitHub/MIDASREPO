     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Support to main sys trans processing')
/*OVR *  OVRDBF FILE(SCACJBPX) TOFILE(SCACJBPD)                       *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC004310 - 'Support' to 'Main' System Transition Processing  *
      *                                                               *
      *  Function:  This module will control the switch from the      *
      *             'support' system to the 'main' system once the    *
      *             close of business has completed.                  *
      *                                                               *
      *  Component of: CBCMOND (Display COB Monitor)                  *
      *                SCC004320  (Midas SC Restart 'Support' to      *
      *                'Main' System Transition Prcocessing)          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. TDA035             Date 02Apr04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    70         Read SCACJBPX                                   *
      *    71         Chain/READE SCSYSTL1                            *
      *    72         SCAN Message Text                               *
      *    73         Error in calling program                        *
      *    U7         Database error                                  *
      *    U8         Database error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRFPHASE  - Cutover Phase is 'F'                             *
      *  SRGPHASE  - Cutover Phase is 'G'                             *
      *  SRHPHASE  - Cutover Phase is 'H'                             *
      *  SRIJPHASE - Cutover Phase is 'IJ'                            *
      *  SRMESS    - Get Next Message to be Sent                      *
      *  SRQCMD    - Subroutine to 'QCMDEXC'                          *
      *  SRTime    - Calculate time                                   *
      * *INZSR     - Initialise subroutine                            *
      * *PSSR      - Error processing                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Processing Date Switch Message File
     FSCSYSTL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Subsystem Jobs in System File
     FSCACJBPX  IF   E             DISK    INFSR(*PSSR) USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
 
      ** Data Area giving Installation Control Details
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Dummy Data Structure used by Access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Dummy Data Structure used by Access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** SF Users File
     D MUSER         E DS                  EXTNAME(MUSERDD)
 
      ** Support to Main System Transition Status Dataarea
     D SCSUPP        E DS           256    EXTNAME(SCSUPP) DTAARA(SCSUPP)
 
      ** 24x7 Status Dataarea
     D SC24X7        E DS           256    EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Bank Details ICD File
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** QCMDEXC dataarea
     D WCommand        DS           100
     D  WCmd1                 18     23
 
     D WCommand2       DS           200
     D  WCmd2                 24    100
     D  WCmd3                101    145
 
      ** Subsystem jobs connected to the system
     D SCACJB          DS           132
     D  WJobName               4     13
     D  WUser                 17     26
     D  WNumber               30     35
     D  WTYPE                 39     43
 
      ** Data structure for time HH:MM:SS
     D DSTimeVar       DS
     D   WHours                1      2S 0
     D   WMinute               3      4S 0
     D   WSecond               5      6S 0
 
      ** Data structure for time MMM:SS
     D DSTimeVar2      DS
     D   WMinute2              1      3S 0
     D   WSecond2              4      5S 0
 
     D WQcmd           S            100    DIM(4) CTDATA PERRCD(1)
     D WQcmd2          S            100    DIM(2) CTDATA PERRCD(1)
     D WMsgTxt         S            100    DIM(5) CTDATA PERRCD(1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter Variables
     D PCMD            S            200
     D PCMDLEN         S             15  5
     D PJobName        S             10
     D PMessage        S            500
     D PNumber         S              6
     D POPTN           S              7
     D PPType          S              1
     D PRTCD           S              7
     D PSubsyst        S              2
     D PSwitch         S              1
     D PUser           S             10
     D PUSRP           S             10
     D PDayNo          S              5  0
     D PDatFmt         S              1
     D PDate           S              6  0
     D PADate          S              7
 
      ** Working Variables
     D WChgTyp         S              1A
     D WNum1           S              6  0
     D WPos            S              3  0
     D WDfltMsg        S            500
     D WDuration       S              5  0
     D WFirstMsg       S              1A
     D WIntUsr         S              1
     D WKey1           S              1
     D WkDate          S              8
     D WLangCode       S              2
     D WMsgType        S              1
     D WMsgTime        S              5  0
     D W_MsgTime       S              5
     D WSecTot         S              5S 0
     D WSecRem         S              5S 0
     D WSec1           S              5S 0
     D WSec2           S              5S 0
     D WSysSecs        S              5S 0
     D WS3TIME         S              5S 0
     D WS3TMNM         S              5S 0
     D WT1MTIM         S              5S 0
     D WTime           S              6  0
     D @RUN            S              1
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Initialise indicators
 
     C                   EVAL      *IN70 = *OFF
     C                   EVAL      *IN71 = *OFF
     C                   EVAL      *IN72 = *OFF
 
     C                   EVAL      WFirstMsg = *BLANKS
 
      ** Print message queue SC24X7Q
 
     C                   EVAL      WCommand = WQcmd(2)
     C                   EVAL      PCMD = WCommand
     C                   Z-ADD     35            PCMDLEN
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD
     C                   PARM                    PCMDLEN
 
      ** Move printed output of SC24X7Q to outq M24X7
 
     C                   EVAL      WCommand = WQcmd(3)
     C                   EVAL      PCMD = WCommand
     C                   Z-ADD     60            PCMDLEN
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD
     C                   PARM                    PCMDLEN
 
      ** Clear message queue SC24X7Q
 
     C                   EVAL      WCommand = WQcmd(4)
     C                   EVAL      PCMD = WCommand
     C                   Z-ADD     21            PCMDLEN
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD
     C                   PARM                    PCMDLEN
 
      ** Access data area SCSUPP
 
     C                   IN        SCSUPP
 
      ** Determine cutover phase in SCSUPP
 
     C                   SELECT
 
     C                   WHEN      S3PHAS = 'F'
     C                   EXSR      SRFPHASE
 
     C                   WHEN      S3PHAS = 'G'
     C                   EXSR      SRGPHASE
 
     C                   WHEN      S3PHAS = 'H'
     C                   EXSR      SRHPHASE
 
     C                   WHEN      S3PHAS = 'I'
     C                             OR S3PHAS = 'J'
     C                   EXSR      SRIJPHASE
 
     C                   ENDSL
 
     C                   DOU       S3PHAS = 'F'
 
      ** Copy spooled file of interactive session in the support system
      ** to SCACJBPX
 
     C                   CALL      'SCC004303'                          73
     C                   PARM      S1SUPP        PSubsyst
     C                   IF        (*INU7 = *ON
     C                             AND *INU8 = *ON)
     C                             OR *IN73 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 001
     C                   EVAL      DBFILE = 'SCC4303'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  Read records from SCACJBPX
 
     C                   OPEN      SCACJBPX
     C     1             SETLL     SCACJBPX
     C                   READ      SCACJBPX                               70
     C                   EVAL      WIntUsr = 'N'
     C                   DOW       *IN70 = *OFF
     C                   IF        WTYPE = 'INTER'
     C                   EVAL      WIntUsr = 'Y'
     C                   ENDIF
     C                   READ      SCACJBPX                               70
     C                   ENDDO
     C                   CLOSE     SCACJBPX
 
      **  Change Cutover Phase to 'F' if no interactive user
 
     C                   IF        WIntUsr = 'N'
     C     *LOCK         IN        SCSUPP
     C                   EVAL      S3PHAS = 'F'
     C                   OUT       SCSUPP
     C                   LEAVE
     C                   ENDIF
 
      ** Access data area SCSUPP
 
     C                   IN        SCSUPP
 
      ** Determine System time
 
     C                   TIME                    WTIME
 
      ** Compare the system time with the 'time of next message' in
      ** dataarea SCSUPP
 
     C                   IF        WTime >= S3TMNM
     C                             OR S3TPNM = ' '
 
      ** Get next message to be sent if 'type of next message' is
      ** blank
 
     C                   IF        S3TPNM = ' '
     C                   EXSR      SRMESS
     C                   EVAL      WFirstMsg = 'M'
     C                   ENDIF
 
      ** Change Cutover Phase to 'F' if type of next message is 'F'
      ** then exit loop
 
     C                   IF        S3TPNM = 'F'
     C     *LOCK         IN        SCSUPP
     C                   EVAL      S3PHAS = 'F'
     C                   OUT       SCSUPP
     C                   LEAVE
     C                   ENDIF
 
      ** Get the default message text for the Language Code equal to
      ** blank
 
     C                   EVAL      WMsgType = S3TPNM
     C                   EVAL      WMsgTime = S3TIME
     C     KTwoKey       CHAIN     SCSYSTL1                           71
     C                   IF        *IN71 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 002
     C                   EVAL      DBFILE = 'SCSYSTL1'
     C                   MOVEL     WMsgTime      W_MsgTime
     C                   EVAL      DBKEY = WMsgType + W_MsgTime
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WDfltMsg = T1MTXT
     C                   ENDIF
 
      ** Copy spooled file of interactive session in the support system to
      ** SCACJBPX
 
     C                   CALL      'SCC004303'                          73
     C                   PARM      S1SUPP        PSubsyst
     C                   IF        (*INU7 = *ON
     C                             AND *INU8 = *ON)
     C                             OR *IN73 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 003
     C                   EVAL      DBFILE = 'SCC4303'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Read records in PF/SCACJBPX
 
     C                   OPEN      SCACJBPX
     C     1             SETLL     SCACJBPX
     C                   READ      SCACJBPX                               70
     C                   DOW       *IN70 = *OFF
 
      ** If interactive session
 
     C                   IF        WTYPE = 'INTER'
 
      ** Get the user language using access object AOUSERR0
 
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      WUser         PUSRP
     C     MUSER         PARM      MUSER         DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 004
     C                   EVAL      DBFILE = 'MUSERDD'
     C                   EVAL      DBKEY = WUser
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Chain to LF/SCSYSTL1 to get the 'Message Text'
 
     C                   EVAL      WMsgType = S3TPNM
     C                   EVAL      WMsgTime = S3TIME
     C                   EVAL      WLangCode = MULT
     C     KThreeK       CHAIN     SCSYSTL1                           71
     C                   IF        *IN71 = *ON
     C                   EVAL      PMessage = WDfltMsg
     C                   ELSE
     C                   EVAL      PMessage = T1MTXT
     C                   ENDIF
 
      ** Convert '{*DATE*}' to Processing_Date
 
     C                   EVAL      WkDate = '{*DATE*}'
     C     WkDate        SCAN      PMessage      WPos                     72
     C                   DOW       *IN72 = *ON
     C                   EVAL      %SUBST(PMessage:WPos:8) = PADATE
     C     WkDate        SCAN      PMessage      WPos                     72
     C                   ENDDO
 
      ** Send break message to interactive session
 
     C                   MOVEL     WNumber       WNum1
     C                   IF        PsJobName <> WJobName
     C                             OR PsUser <> WUser
     C                             OR PsJobNo <> WNum1
     C                   CALL      'SCC004305'                          73
     C                   PARM      'S'           PPType
     C                   PARM      WJobName      PJobName
     C                   PARM      *BLANKS       PUser
     C                   PARM                    PNumber
     C                   PARM                    PMessage
 
     C                   IF        (*INU7 = *ON
     C                             AND *INU8 = *ON)
     C                             OR *IN73 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 005
     C                   EVAL      DBFILE = 'SCC4305'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Send program message to SC24X7Q when sending break messages
      ** to users in Support System
 
     C                   IF        WFirstMsg = 'M'
     C                   EVAL      WCommand2 = WQcmd2(1) + WQcmd2(2)
     C                   MOVEA     WMsgTxt(1)    WCmd2
     C                   MOVEA     WMsgTxt(2)    WCmd3
     C                   EVAL      PCMD = WCommand2
     C                   Z-ADD     165           PCMDLEN
     C                   EXSR      SRQCMD
     C                   EVAL      WFirstMsg = *Blanks
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SCACJBPX                               70
     C                   ENDDO
     C                   CLOSE     SCACJBPX
 
      ** Get the next message to be sent
 
     C                   EXSR      SRMESS
 
     C     *LOCK         IN        SC24X7
     C                   EVAL      S1SOVR = ' '
     C                   OUT       SC24X7
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EXSR      SRFPHASE
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFPHASE - Subroutine when Cutover phase is 'F'               *
      *                                                               *
      * Called by: Main Subroutine                                    *
      *                                                               *
      * Calls: SRGPHASE, SCC004303, SCC004305, AOUSERR0               *
      *                                                               *
      *****************************************************************
     C     SRFPHASE      BEGSR
 
     C     *LOCK         IN        SC24X7
     C                   EVAL      S1SOVR = ' '
     C                   OUT       SC24X7
 
      ** Copy spooled file of interactive session in the support system to
      ** SCACJBPX
 
     C                   CALL      'SCC004303'                          73
     C                   PARM      S1SUPP        PSubsyst
 
     C                   IF        (*INU7 = *ON
     C                             AND *INU8 = *ON)
     C                             OR *IN73 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 006
     C                   EVAL      DBFILE = 'SCC4303'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   OPEN      SCACJBPX
     C     1             SETLL     SCACJBPX
     C                   READ      SCACJBPX                               70
 
     C                   DOW       *IN70 = *OFF
     C                   IF        WTYPE = 'INTER'
 
     C                   MOVEL     WNumber       WNum1
     C                   IF        WJobName <> PsJobName
     C                             OR WUser <> PsUser
     C                             OR WNum1 <> PsJobNo
 
      ** End jobs of interactive sessions
 
     C                   CALL      'SCC004305'                          73
     C                   PARM      'E'           PPType
     C                   PARM      WJobName      PJobName
     C                   PARM      WUser         PUser
     C                   PARM      WNumber       PNumber
     C                   PARM                    PMessage
 
     C                   IF        (*INU7 = *ON
     C                             AND *INU8 = *ON)
     C                             OR *IN73 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 007
     C                   EVAL      DBFILE = 'SCC4305'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SCACJBPX                               70
     C                   ENDDO
     C                   CLOSE     SCACJBPX
 
      ** Send program message to SC24X7Q when ending interactive
      ** sessions in Support System
 
     C                   IF        PPType = 'E'
     C                   EVAL      WCommand2 = WQcmd2(1) + WQcmd2(2)
     C                   MOVEA     WMsgTxt(3)    WCmd2
     C                   EVAL      PCMD = WCommand2
     C                   Z-ADD     165           PCMDLEN
     C                   EXSR      SRQCMD
     C                   ENDIF
 
     C                   EVAL      WKey1 = 'F'
     C     WKey1         CHAIN     SCSYSTL1                           71
     C                   IF        *IN71 = *OFF
     C                   EVAL      WDfltMsg = T1MTXT
 
      ** Copy spooled file of interactive session in the main system
      ** to SCACJBPX
 
     C                   CALL      'SCC004303'                          73
     C                   PARM      S1MAIN        PSubsyst
     C                   IF        (*INU7 = *ON
     C                             AND *INU8 = *ON)
     C                             OR *IN73 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 008
     C                   EVAL      DBFILE = 'SCC4303'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   OPEN      SCACJBPX
     C     1             SETLL     SCACJBPX
     C                   READ      SCACJBPX                               70
     C                   DOW       *IN70 = *OFF
     C                   IF        WTYPE = 'INTER'
 
      ** Get the user language using access object AOUSERR0
 
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      WUser         PUSRP
     C     MUSER         PARM      MUSER         DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 009
     C                   EVAL      DBFILE = 'MUSERDD'
     C                   EVAL      DBKEY = WUser
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Chain to LF/SCSYSTL1 to get the 'Message Text'
 
     C                   EVAL      WMsgType = 'F'
     C                   EVAL      WFirstMsg = 'F'
     C                   EVAL      WMsgTime = 0
     C                   EVAL      WLangCode = MULT
     C     KThreeK       CHAIN     SCSYSTL1                           71
     C                   IF        *IN71 = *ON
     C                   EVAL      PMessage = WDfltMsg
     C                   ELSE
     C                   EVAL      PMessage = T1MTXT
     C                   ENDIF
 
      ** Convert '{*DATE*}' to Processing_Date
 
     C                   EVAL      WkDate = '{*DATE*}'
     C     WkDate        SCAN      PMessage      WPos                     72
     C                   DOW       *IN72 = *ON
     C                   EVAL      %SUBST(PMessage:WPos:8) = PADATE
     C     WkDate        SCAN      PMessage      WPos                     72
     C                   ENDDO
 
      ** Send break message to interactive session
 
     C                   MOVEL     WNumber       WNum1
     C                   IF        PsJobName <> WJobName
     C                             OR PsUser <> WUser
     C                             OR PsJobNo <> WNum1
     C                   CALL      'SCC004305'                          73
     C                   PARM      'S'           PPType
     C                   PARM      WJobName      PJobName
     C                   PARM      *BLANKS       PUser
     C                   PARM                    PNumber
     C                   PARM                    PMessage
 
     C                   IF        (*INU7 = *ON
     C                             AND *INU8 = *ON)
     C                             OR *IN73 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 010
     C                   EVAL      DBFILE = 'SCC4305'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   READ      SCACJBPX                               70
     C                   ENDDO
     C                   CLOSE     SCACJBPX
 
      ** Send program message to SC24X7Q when sending break messages
      ** to interactive sessions in Main System
 
     C                   IF        WFirstMsg = 'F'
     C                   EVAL      WCommand2 = WQcmd2(1) + WQcmd2(2)
     C                   MOVEA     WMsgTxt(5)    WCmd2
     C                   EVAL      PCMD = WCommand2
     C                   Z-ADD     165           PCMDLEN
     C                   EXSR      SRQCMD
     C                   EVAL      WFirstMsg = *Blanks
     C                   ENDIF
 
     C                   ENDIF
 
     C     *LOCK         IN        SCSUPP
     C                   EVAL      S3PHAS = 'G'
     C                   OUT       SCSUPP
 
     C                   EXSR      SRGPHASE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGPHASE - Subroutine when Cutover phase is 'G'               *
      *                                                               *
      * Called by: Main Subroutine, SRFPHASE                          *
      *                                                               *
      * Calls: SRHPHASE, SCC004307                                    *
      *                                                               *
      *****************************************************************
     C     SRGPHASE      BEGSR
 
      ** Switch MQ series queues 'support' system to 'main' system
 
     C                   CALL      'SCC004307'                          73
     C                   PARM      ' '           PSwitch
 
     C                   IF        (*INU7 = *ON
     C                             AND *INU8 = *ON)
     C                             OR *IN73 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 011
     C                   EVAL      DBFILE = 'SCC4307'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     *LOCK         IN        SCSUPP
     C                   EVAL      S3PHAS = 'H'
     C                   OUT       SCSUPP
 
     C                   EXSR      SRHPHASE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHPHASE - Subroutine when phase is 'H'                       *
      *                                                               *
      * Called by: Main Subroutine, SRGPHASE                          *
      *                                                               *
      * Calls: SRIJPHASE, SC004311                                    *
      *                                                               *
      *****************************************************************
     C     SRHPHASE      BEGSR
 
      ** Copy contents of API log files into the API MQ series message
      ** queues of the main system
 
     C                   CALL      'SC004311'                           73
     C                   PARM      ' '           PSwitch
 
     C                   IF        (*INU7 = *ON
     C                             AND *INU8 = *ON)
     C                             OR *IN73 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 012
     C                   EVAL      DBFILE = 'SC4311'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Send program message to SC24X7Q when copying API log files
      ** to MQ Series message queues of the Main System
 
     C                   EVAL      WCommand2 = WQcmd2(1) + WQcmd2(2)
     C                   MOVEA     WMsgTxt(4)    WCmd2
     C                   MOVEA     WMsgTxt(2)    WCmd3
     C                   EVAL      PCMD = WCommand2
     C                   Z-ADD     165           PCMDLEN
     C                   EXSR      SRQCMD
 
     C     *LOCK         IN        SCSUPP
     C                   EVAL      S3PHAS = 'I'
     C                   OUT       SCSUPP
 
     C                   EXSR      SRIJPHASE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRIJPHASE - Subroutine when phase is 'I' or 'J'               *
      *                                                               *
      * Called by: Main Subroutine, SRHPHASE                          *
      *                                                               *
      *****************************************************************
     C     SRIJPHASE     BEGSR
      *
      ** Seton *INLR to end the program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMESS - Generate Next message to be sent                     *
      *                                                               *
      * Called by: Main Subroutine                                    *
      *                                                               *
      * Calls: SRTime                                                 *
      *                                                               *
      *****************************************************************
     C     SRMESS        BEGSR
 
     C     *LOCK         IN        SCSUPP
     C                   EVAL      S3TMLM = S3TMNM
     C                   EVAL      S3TPLM = S3TPNM
 
      ** If 'type of last message' is blank
 
     C                   IF        S3TPLM = ' '
 
      ** Access the first record of message type 'M'
 
     C                   EVAL      WKey1 = 'M'
     C     WKey1         CHAIN     SCSYSTL1                           71
 
     C                   ELSE
 
      ** Access the last message sent
 
     C                   EVAL      WMsgType = S3TPLM
     C                   EVAL      WMsgTime = S3TIME
     C     KTwoKey       SETGT     SCSYSTL1                           71
     C                   IF        *IN71 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 013
     C                   EVAL      DBFILE = 'SCSYSTL1'
     C                   MOVEL     WMsgTime      W_MsgTime
     C     WMsgType      CAT       W_MsgTime:1   DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Do a READE using a partial key 'type of last message'
 
     C                   EVAL      WKey1 = S3TPLM
     C     WKey1         READE     SCSYSTL1                               71
     C                   ENDIF
 
      ** If no record found
 
     C                   IF        *IN71 = *ON
     C                   EVAL      S3TPNM = 'F'
 
      ** Convert system time to seconds
 
     C                   MOVE      WTime         DSTimeVar
     C                   EVAL      WChgTyp = '1'
     C                   EXSR      SRTime
     C                   EVAL      WSysSecs = WSecTot
 
      ** Convert S3TIME to seconds
 
     C                   MOVE      S3TIME        DSTimeVar2
     C                   EVAL      WChgTyp   = '2'
     C                   EXSR      SRTime
     C                   EVAL      WS3Time = WSecTot
 
     C                   EVAL      WS3TMNM = WSysSecs + WS3TIME
 
      ** Convert WS3TMNM (SSSSS) to S3TMNM (HH:MM:SS)
 
     C                   EVAL      WSecTot = WS3TMNM
     C                   EVAL      WChgTyp = '3'
     C                   EXSR      SRTime
     C                   MOVE      DSTimeVar     S3TMNM
 
     C                   EVAL      S3TIME = 0
 
     C                   ELSE
 
      ** If record found
 
     C                   EVAL      S3TPNM = T1MTYP
 
      ** 'type of last message' is blank
 
     C                   IF        S3TPLM = ' '
     C                   EVAL      S3TMNM = WTime
     C                   ELSE
     C                   IF        S3TPLM = S3TPNM
 
      ** Convert S3TIME to seconds
 
     C                   MOVE      S3TIME        DSTimeVar2
     C                   EVAL      WChgTyp = '2'
     C                   EXSR      SRTime
     C                   EVAL      WS3Time = WSecTot
 
      ** Convert T1MTIM to seconds
 
     C                   MOVE      T1MTIM        DSTimeVar2
     C                   EVAL      WChgTyp = '2'
     C                   EXSR      SRTime
     C                   EVAL      WT1MTIM = WSecTot
     C
     C                   EVAL      WDuration = WS3TIME - WT1MTIM
     C                   ELSE
 
      ** Convert S3TIME to seconds
 
     C                   MOVE      S3TIME        DSTimeVar2
     C                   EVAL      WChgTyp = '2'
     C                   EXSR      SRTime
     C                   EVAL      WS3Time = WSecTot
     C                   EVAL      WDuration = WS3TIME
     C                   ENDIF
 
      ** Convert System time (WSysTime) to seconds
 
     C                   MOVE      WTime         DSTimeVar
     C                   EVAL      WChgTyp = '1'
     C                   EXSR      SRTime
     C                   EVAL      WSysSecs = WSecTot
 
      ** Add WDuration to WSysSecs (Duration + System Time)
      ** Convert WS3TMNM (SSSSS) to S3TMNM (HH:MM:SS)
 
     C                   EVAL      WS3TMNM = WSysSecs + WDuration
     C                   EVAL      WSecTot = WS3TMNM
     C                   EVAL      WChgTyp = '3'
     C                   EXSR      SRTime
     C                   MOVE      DSTimeVar     S3TMNM
     C                   ENDIF
 
      ** Initialise 'message time' in SCSUPP to 'Message Time' in
      ** LF/SCSYSTL1
 
     C                   EVAL      S3TIME = T1MTIM
 
     C                   ENDIF
 
     C                   OUT       SCSUPP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTime - Subroutine to Calculate time                         *
      *                                                               *
      * Called by: SRMESS                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRTime        BEGSR
 
     C                   SELECT
 
      ** Convert HH:MM:SS to SSSSS
 
     C                   WHEN      WChgTyp = '1'
     c                   EVAL      WSec1 = WHours * 3600
     C                   EVAL      WSec2 = WMinute * 60
     C                   EVAL      WSecTot = WSec1 + WSec2 + WSecond
 
      ** Convert MMM:SS to SSSSS
 
     C                   WHEN      WChgTyp = '2'
     C                   EVAL      WSec1 = WMinute2 * 60
     C                   EVAL      WSecTot = WSec1 + WSecond2
 
      ** Convert SSSSS to HH:MM:SS
 
     C                   WHEN      WChgTyp = '3'
     C                   EVAL      WHours = WSecTot / 3600
     c                   EVAL      WSec1 = WHours * 3600
     C                   EVAL      WSecRem = WSecTot - WSec1
     C                   EVAL      WMinute = WSecRem / 60
     c                   EVAL      WSec2   =  WMinute * 60
     C                   EVAL      WSecond = WSecRem - WSec2
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRQCMD - Subroutine to 'QCMDEXC'                              *
      *                                                               *
      * Called by: Main Subroutine                                    *
      *                                                               *
      * Calls: Main Subroutine, SRFPHASE, SRGPHASE, SRHPHASE,         *
      *        SRIJPHASE                                              *
      *                                                               *
      *****************************************************************
     C     SRQCMD        BEGSR
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD
     C                   PARM                    PCMDLEN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: QCMDEXC, AOBANKR0, ZDATE2                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Intialise dataarea SCMAIN and SCREOP to blanks
 
     C                   EVAL      WCommand = WQcmd(1)
     C                   EVAL      WCmd1 = 'SCMAIN'
     C                   EVAL      PCMD = WCommand
     C                   Z-ADD     35            PCMDLEN
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD
     C                   PARM                    PCMDLEN
 
     C                   EVAL      WCommand = WQcmd(1)
     C                   EVAL      WCmd1 = 'SCREOP'
     C                   EVAL      PCMD = WCommand
     C                   Z-ADD     35            PCMDLEN
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD
     C                   PARM                    PCMDLEN
 
      ** Initialise 'Re-open Option' in SC24X7 to blanks
 
     C     *LOCK         IN        SC24X7
     C                   EVAL      S1REOP = *BLANKS
     C                   OUT       SC24X7
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SC004310'
     C                   OUT       LDA
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 014
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Convert Processing Date
 
     C                   CALL      'ZDATE2'
     C                   PARM      S1Date        PDayNo
     C                   PARM      BJDFIN        PDatFmt
     C                   PARM                    PDate
     C                   PARM                    PADate
 
     C     KTwoKey       KLIST
     C                   KFLD                    WMsgType
     C                   KFLD                    WMsgTime
 
     C     KThreeK       KLIST
     C                   KFLD                    WMsgType
     C                   KFLD                    WMsgTime
     C                   KFLD                    WLangCode
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** WQcmd
CHGDTAARA DTAARA(      ) VALUE(' ')
DSPMSG MSGQ(SC24X7Q) OUTPUT(*PRINT)
CHGSPLFA FILE(QPDSPMSG) SPLNBR(*LAST) OUTQ(M24X7) SAVE(*YES)
CLRMSGQ MSGQ(SC24X7Q)
** WQcmd2
SNDMSG MSG('SC004310 -
                                              ') TOMSGQ(SC24X7Q)
** WMsgTxt
Switchover from "Support" to "Main" System message sent to users in Support
System.
Users connected in Support System are cancelled.
Contents of API log file now copied into the MQ Series message queue of Main
''Completion of Transition'' message sent to users in Main System.
