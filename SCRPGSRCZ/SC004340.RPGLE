     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC 24x7 re-open input cycle processing')
/*OVR *  OVRDBF FILE(SCACJBPX) TOFILE(SCACJBPD)                       *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC004340 - 24x7 Reopen Input Cycle Processing                *
      *                                                               *
      *  Function:  This module will handle the action to taken on    *
      *             the 'Support' system once the input-cycle is      *
      *             re-opened.                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. TDA035             Date 02Apr04               *
      *                 CSC023             Date 28Jan04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CSC023 - SBMJOB output queue must be *JOBD.                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file Indicator                           *
      *    02         Record not found Indicator                      *
      *    03         Error in called program                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit      - Initial Processing                             *
      *  SRMainProc  - Main Processing                                *
      *  SRFPhase    - 'F' Phase of Cutover                           *
      *  SRGPhase    - 'G' Phase of Cutover                           *
      *  SRHPhase    - 'H' Phase of Cutover                           *
      *  SRIJPhase   - 'I' and 'J' Phase of Cutover                   *
      *  SRSCC4303   - Call to program SCC4303                        *
      *  SRSCC4305   - Call to program SCC4305                        *
      *  SRGetNxtMsg - Get next message subroutine                    *
      *  SRAOUser    - Call to program AOUSERR0                       *
      *  SRZDATE2    - Format a date for output                       *
      *  SRQCMD      - Call QCMDEXC                                   *
      *  SRCvtTime   - Convert Time                                   *
      *  SREndP      - End Program                                    *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSCACJBPX  IF   E             DISK    INFSR(*PSSR) USROPN
      ** Subsystem Jobs connected to the system
 
     FSCSYSTL1  IF   E           K DISK    INFSR(*PSSR)
      ** Processing Date Switch Message file
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      **
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array containing commands to be issued
      ** Array containing command lengths
      ** Array containing Messages
     D WCmdArr         S            100    DIM(11) CTDATA PERRCD(1)
     D WCmdLenArr      S              4  0 DIM(11) CTDATA PERRCD(1)
     D WMsgTxt         S            100    DIM(10) CTDATA PERRCD(1)
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  NoRecFnd              02     02
     D  ErrInPgm              03     03
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for user details
     D MUSER         E DS                  EXTNAME(MUSERDD)
 
      ** Data structure for SC24X7 details
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Data structure for SCREOP details
     D SCREOP        E DS                  EXTNAME(SCREOP) DTAARA(SCREOP)
 
      ** Data structure for SCMAIN details
     D SCMAIN        E DS                  EXTNAME(SCMAIN) DTAARA(SCMAIN)
 
      ** Data structure for SCSUPP details
     D SCSUPP        E DS                  EXTNAME(SCSUPP) DTAARA(SCSUPP)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data structure for time HH:MM:SS
     D DSTimeVar       DS
     D   WHours                1      2S 0
     D   WMinute               3      4S 0
     D   WSecond               5      6S 0
 
      ** Data structure for time MMM:SS
     D DSTimeVar2      DS
     D   WMinute2              1      3S 0
     D   WSecond2              4      5S 0
 
      ** QCMDEXC data structure
     D WCommand2       DS           200
     D  WCmd2                 24    100
     D  WCmd3                101    180
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter variables
 
     D PDayNum         S              5  0
     D PDate           S              6S 0
     D PDateAlp        S              7A
 
     D PSysPref        S              2A
 
     D PProcType       S              1A
     D PJobName        S             10A
     D PUser           S             10A
     D PJobNum         S              6A
     D PMsgText        S            500A
 
     D PSwOvrMode      S              1A
 
     D PCmd            S            200A
     D PCmdLen         S             15  5
 
     D PUsrProf        S             10A
 
      ** KLIST variables
 
     D KMsgType        S              1A
     D KMsgTime        S              5S 0
     D KLangCde        S              2A
 
      ** Work variables
 
     D WUsrInter       S              1A
     D WSysTime        S              6S 0
     D WFirstMsg       S              1A
     D WDefMsgTxt      S            500A
     D WEnd            S              4S 0
     D WSend           S              4S 0
     D WUserLang       S              2A
     D WMsgText        S            500A
     D WStrtPos        S              3S 0
     D WJobName        S             10A
     D WUser           S             10A
     D WJobNum         S              6A
     D WJobNo          S              6S 0
     D WDate           S              8A
     D WDuration       S              5S 0
     D Proc_D          S              8A
     D Proc_Dte        S              7A
     D WMsgTime        S              5A
     D WSecTot         S              5S 0
     D WSecRem         S              5S 0
     D WSec1           S              5S 0
     D WSec2           S              5S 0
     D WSysSecs        S              5S 0
     D WS4TIME         S              5S 0
     D WS4TMNM         S              5S 0
     D WT1MTIM         S              5S 0
     D WCvtTyp         S              1A
     D WScnFlg         S              1A
     D WLib            S              6A
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Initial Processing
 
     C                   EXSR      SRInit
 
      ** Main Processing
 
     C                   EXSR      SRMainProc
 
      ** End Program
 
     C                   EXSR      SREndp
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initial Processing                                   *
      *                                                               *
      * Called by:  Main Processing                                   *
      *                                                               *
      * Calls: SRQCMD, SCC000030                                      *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Initialise dataara SCMAIN
 
     C     *LOCK         IN        SCMAIN
     C                   EVAL      S2STAT = *BLANKS
     C                   EVAL      S2PHAS = *BLANKS
     C                   EVAL      S2BKJB = *BLANKS
     C                   EVAL      S2JRNE = *BLANKS
     C                   EVAL      S2TMLM = *ZERO
     C                   EVAL      S2TPLM = *BLANKS
     C                   EVAL      S2TMNM = *ZERO
     C                   EVAL      S2TPNM = *BLANKS
     C                   EVAL      S2TIME = *ZERO
     C                   EVAL      S2FILL = *BLANKS
     C                   OUT       SCMAIN
 
      ** Initialise dataara SCSUPP
 
     C     *LOCK         IN        SCSUPP
     C                   EVAL      S3STRT = *BLANKS
     C                   EVAL      S3PHAS = *BLANKS
     C                   EVAL      S3SOPT = *BLANKS
     C                   EVAL      S3SAVF = *BLANKS
     C                   EVAL      S3TMLM = *ZERO
     C                   EVAL      S3TPLM = *BLANKS
     C                   EVAL      S3TMNM = *ZERO
     C                   EVAL      S3TPNM = *BLANKS
     C                   EVAL      S3TIME = *ZERO
     C                   EVAL      S3FILL = *BLANKS
     C                   OUT       SCSUPP
 
     C                   EVAL      WFirstMsg = *BLANKS
     C                   EVAL      WEnd = 0
     C                   EVAL      WSend = 0
     C
 
      ** Clear message queue MOPERQ in support system
 
     C                   EVAL      PCmd    = WCmdArr(5)
     C                   Z-ADD     WCmdLenArr(5) PCmdLen
     C                   EXSR      SRQCMD
 
 
      ** Clear message queue MRUNQ in support system
 
     C                   EVAL      PCmd    = WCmdArr(6)
     C                   Z-ADD     WCmdLenArr(6) PCmdLen
     C                   EXSR      SRQCMD
 
      ** Clear message queue MSTATUS in support system
 
     C                   EVAL      PCmd    = WCmdArr(7)
     C                   Z-ADD     WCmdLenArr(7) PCmdLen
     C                   EXSR      SRQCMD
 
      ** Clear message queue MSPECIAL in support system
 
     C                   EVAL      PCmd    = WCmdArr(8)
     C                   Z-ADD     WCmdLenArr(8) PCmdLen
     C                   EXSR      SRQCMD
 
      ** Initialise Data Replication files and Data area (SCDRSTAT)
 
     C                   CALL      'SCC000030'                          03
 
     C                   IF        *INU7 = True and *INU8 = True or
     C                             ErrInPgm = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 001
     C                   EVAL      DBFILE = 'SCC0030'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Send message to SC24X7Q to initialise Data Replication files
      ** and data area
 
     C                   EVAL      WCommand2 = WCmdArr(9) + WCmdArr(10)
     C                   MOVEA     WMsgTxt(8)    WCmd2
     C                   EVAL      PCMD = WCommand2
     C                   EVAL      PCmdLen = WCmdLenArr(9) + WCmdLenArr(10)
     C                   EXSR      SRQCMD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMainProc - Main Processing                                  *
      *                                                               *
      * Called by:  Main                                              *
      *                                                               *
      * Calls: SRQCMD, SRZDATE2, SRFPhase, SRGPhase, SRHPhase         *
      *        SRIJPhase, SRGetNxtMsg, SRSCC4303, SRSCC4305, SRAOUser *
      *        SCC000600, *PSSR                                       *
      *                                                               *
      *****************************************************************
     C     SRMainProc    BEGSR
 
 
      ** If reopen option is '1' or blank
 
     C                   IF        S1REOP = '1' or S1REOP = *BLANKS
 
      ** Start data replication
 
     C                   CALL      'SCC000600'                          03
 
     C                   IF        *INU7 = True and *INU8 = True or
     C                             ErrInPgm = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBFILE =  'SCC0600'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Send message to SC24X7Q to start data replication
 
     C                   EVAL      WCommand2 = WCmdArr(9) + WCmdArr(10)
     C                   MOVEA     WMsgTxt(9)    WCmd2
     C                   EVAL      PCMD = WCommand2
     C                   EVAL      PCmdLen = WCmdLenArr(9) + WCmdLenArr(10)
     C                   EXSR      SRQCMD
 
      ** Move 'Z' to Cutover Phase in dataarea SCREOP
      ** Move *BLANKS to reopen started in dataarea SCREOP
 
     C     *LOCK         IN        SCREOP
     C                   EVAL      S4STRT = *BLANKS
     C                   EVAL      S4PHAS = 'Z'
     C                   OUT       SCREOP
 
      ** Support to Main Transition completed succesfully
 
     C                   EVAL      WCommand2 = WCmdArr(9) + WCmdArr(10)
     C                   MOVEA     WMsgTxt(10)   WCmd2
     C                   EVAL      PCMD = WCommand2
     C                   EVAL      PCmdLen = WCmdLenArr(9) + WCmdLenArr(10)
     C                   EXSR      SRQCMD
 
      ** Exit from program
 
     C                   EXSR      SREndP
 
     C                   ENDIF
 
      ** Convert processing date
 
     C                   EVAL      PDayNum = S1DATE
     C                   EXSR      SRZDATE2
     C                   EVAL      Proc_Dte =  PDateAlp
     C                   MOVEL     Proc_Dte      Proc_D
 
      ** Determine cutover phase
 
     C                   SELECT
     C                   WHEN      S4PHAS = 'F'
     C                   EXSR      SRFPhase
     C                   WHEN      S4PHAS = 'G'
     C                   EXSR      SRGPhase
     C                   WHEN      S4PHAS = 'H'
     C                   EXSR      SRHPhase
     C                   WHEN      S4PHAS = 'I' or S4PHAS = 'J'
     C                   EXSR      SRIJPhase
     C                   ENDSL
 
     C                   DOU       S4PHAS = 'F'
 
      ** Determine all interactive users still connected to the support system
 
     C                   EVAL      PSysPref  = S1SUPP
     C                   EXSR      SRSCC4303
 
      ** Read all records in SCACJBPX
 
     C                   EVAL      WUsrInter = 'N'
     C                   OPEN      SCACJBPX
     C     1             SETLL     SCACJBPX
     C                   READ      SCACJBPX                               01
 
     C                   DOW       EndOfFile = False
     C                   IF        %SUBST(SCACJB:39:5) = 'INTER'
     C                   EVAL      WUsrInter = 'Y'
     C                   ENDIF
     C                   READ      SCACJBPX                               01
     C                   ENDDO
 
     C                   CLOSE     SCACJBPX
 
      ** If no interactive user is connected to the system
 
     C                   IF        WUsrInter = 'N'
     C                   LEAVE
     C                   ENDIF
 
      ** Get system time
 
     C                   TIME                    WSysTime
 
     C                   IF        WSysTime >= S4TMNM or
     C                             S4TPNM = *BLANKS
 
     C                   IF        S4TPNM = *BLANKS
 
      ** Get next message to be sent
 
     C                   EXSR      SRGetNxtMsg
 
     C                   ENDIF
 
     C                   IF        S4TPNM = 'X'
     C                   LEAVE
     C                   ENDIF
 
     C                   EVAL      KMsgType = S4TPNM
     C                   EVAL      KMsgTime = S4TIME
     C                   EVAL      KLangCde = *BLANKS
     C                   MOVEL     KMsgTime      WMsgTime
 
     C     Keylist2      CHAIN     SCSYSTL1                           02
 
     C                   IF        NoRecFnd = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  =  003
     C                   EVAL      DBFILE =  'SCSYSTL1'
     C                   EVAL      DBKEY  =  KMsgType + WMsgTime + KLangCde
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WDefMsgTxt = T1MTXT
     C                   ENDIF
 
      ** Determine all interactive users still connected to the support system
 
     C                   EVAL      PSysPref  = S1SUPP
     C                   EXSR      SRSCC4303
 
      ** Read all records in SCACJBPX
 
     C                   OPEN      SCACJBPX
     C     1             SETLL     SCACJBPX
     C                   READ      SCACJBPX                               01
 
     C                   DOW       EndOfFile = False
     C                   IF        %SUBST(SCACJB:39:5) = 'INTER'
     C                   EVAL      WJobName = %SUBST(SCACJB:4:10)
     C                   EVAL      WUser    = %SUBST(SCACJB:17:10)
 
      ** Access AOUSERR0 to get the user language code
 
     C                   EXSR      SRAOUser
 
     C                   EVAL      KMsgType = S4TPNM
     C                   EVAL      KMsgTime = S4TIME
     C                   EVAL      KLangCde = WUserLang
 
     C     Keylist1      CHAIN     SCSYSTL1                           02
 
     C                   IF        NoRecFnd = True
     C                   EVAL      WMsgText = WDefMsgTxt
     C                   ELSE
     C                   EVAL      WMsgText = T1MTXT
     C                   ENDIF
 
      ** Scan message text for '{*DATE*}'
 
     C                   EVAL      WDate = '{*DATE*}'
     C                   EVAL      WScnFlg = 'Y'
     C                   DOW       WScnFlg = 'Y'
     C     WDate         SCAN      WMsgText      WStrtPos
     C                   IF        WStrtPos > 0
     C                   EVAL      %SUBST(WMsgText:WStrtPos:8) = Proc_D
     C                   EVAL      WScnFlg = 'Y'
     C                   ELSE
     C                   EVAL      WScnFlg = 'N'
     C                   ENDIF
     C                   ENDDO
 
      ** Send a break message to an interactive user by calling SCC4305
 
     C                   EVAL      PProcType = 'S'
     C                   EVAL      PJobName  = WJobName
     C                   EVAL      PUser     = *BLANKS
     C                   EVAL      PJobNum   = *BLANKS
     C                   EVAL      PMsgText  = WMsgText
     C                   EXSR      SRSCC4305
 
     C                   ENDIF
 
     C                   READ      SCACJBPX                               01
     C                   ENDDO
 
     C                   CLOSE     SCACJBPX
 
      ** Send program message to SC24X7Q when sending break
      ** message to an interactive user in Support System
 
     C                   IF        WFirstMsg = 'V'
     C                             OR WFirstMsg = 'W'
     C                   EVAL      WCommand2 = WCmdArr(9) + WCmdArr(10)
     C                   MOVEA     WMsgTxt(1)    WCmd2
     C                   MOVEA     WMsgTxt(2)    WCmd3
     C                   EVAL      PCMD = WCommand2
     C                   EVAL      PCmdLen = WCmdLenArr(9) + WCmdLenArr(10)
     C                   EXSR      SRQCMD
     C                   EVAL      WFirstMsg = *Blanks
     C                   ENDIF
 
      ** Get next message to be sent
 
     C                   EXSR      SRGetNxtMsg
 
      ** Move blanks to switchover mode in data area SC24X7
 
     C     *LOCK         IN        SC24X7
     C                   EVAL      S1SOVR = ' '
     C                   OUT       SC24X7
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** Move 'F' to Cutover Phase in dataarea SCREOP
 
     C     *LOCK         IN        SCREOP
     C                   EVAL      S4PHAS = 'F'
     C                   OUT       SCREOP
 
     C                   EXSR      SRFPhase
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFPhase - 'F' Phase of Cutover                               *
      *                                                               *
      * Called by: SRMainProc                                         *
      *                                                               *
      * Calls: SRSCC4303, SRSCC4305, SRAOUser, SRGPhase               *
      *                                                               *
      *****************************************************************
     C     SRFPhase      BEGSR
 
      ** Move blanks to switchover mode in data area SC24X7
 
     C     *LOCK         IN        SC24X7
     C                   EVAL      S1SOVR = ' '
     C                   OUT       SC24X7
 
      ** Determine all interactive users still connected to the support system
 
     C                   EVAL      PSysPref  = S1SUPP
     C                   EXSR      SRSCC4303
 
      ** Read all records in SCACJBPX
 
     C                   OPEN      SCACJBPX
     C     1             SETLL     SCACJBPX
     C                   READ      SCACJBPX                               01
 
     C                   DOW       EndOfFile = False
     C                   IF        %SUBST(SCACJB:39:5) = 'INTER'
     C                   EVAL      WJobName = %SUBST(SCACJB:4:10)
     C                   EVAL      WUser    = %SUBST(SCACJB:17:10)
     C                   EVAL      WJobNum  = %SUBST(SCACJB:30:6)
 
     C                   MOVE      WJobNum       WJobNo
     C                   IF        WJobName <> PSJobName or
     C                             WUser    <> PSUser    or
     C                             WJobNo   <> PSJobNo
 
      ** Call SCC4305 to cancel an interactive session connected to the system
 
     C                   EVAL      PProcType = 'E'
     C                   EVAL      PJobName  = WJobName
     C                   EVAL      PUser     = WUser
     C                   EVAL      PJobNum   = WJobNum
     C                   EVAL      PMsgText  = *BLANKS
     C                   EXSR      SRSCC4305
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SCACJBPX                               01
     C                   ENDDO
 
     C                   CLOSE     SCACJBPX
 
      ** Send program message to SC24X7Q to cancel an interactive
      ** session connected to the Support system
 
     C                   IF        PProcType = 'E'
     C                   EVAL      WCommand2 = WCmdArr(9) + WCmdArr(10)
     C                   MOVEA     WMsgTxt(3)    WCmd2
     C                   EVAL      PCMD = WCommand2
     C                   EVAL      PCmdLen = WCmdLenArr(9) + WCmdLenArr(10)
     C                   EXSR      SRQCMD
     C                   ENDIF
 
     C                   EVAL      KMsgType = 'X'
     C                   EVAL      KMsgTime = *ZERO
     C                   EVAL      KLangCde = *BLANKS
 
     C     KMsgType      CHAIN     SCSYSTL1                           02
 
     C                   IF        NoRecFnd = False
 
     C                   EVAL      WDefMsgTxt = T1MTXT
 
      ** Determine all interactive users still connected to the main system
 
     C                   EVAL      PSysPref  = S1MAIN
     C                   EXSR      SRSCC4303
 
      ** Read all records in SCACJBPX
 
     C                   OPEN      SCACJBPX
     C     1             SETLL     SCACJBPX
     C                   READ      SCACJBPX                               01
 
     C                   DOW       EndOfFile = False
     C                   IF        %SUBST(SCACJB:39:5) = 'INTER'
     C                   EVAL      WJobName = %SUBST(SCACJB:4:10)
     C                   EVAL      WUser    = %SUBST(SCACJB:17:10)
 
      ** Access AOUSERR0 to get the user language
 
     C                   EXSR      SRAOUser
 
     C                   EVAL      KMsgType = 'X'
     C                   EVAL      KMsgTime = *ZERO
     C                   EVAL      KLangCde = WUserLang
 
     C     Keylist1      CHAIN     SCSYSTL1                           02
 
     C                   IF        NoRecFnd = True
     C                   EVAL      WMsgText = WDefMsgTxt
     C                   ELSE
     C                   EVAL      WMsgText = T1MTXT
     C                   ENDIF
 
      ** Scan message text for '{*DATE*}'
 
     C                   EVAL      WDate = '{*DATE*}'
     C                   EVAL      WScnFlg = 'Y'
     C                   DOW       WScnFlg = 'Y'
     C     WDate         SCAN      WMsgText      WStrtPos
     C                   IF        WStrtPos > 0
     C                   EVAL      %SUBST(WMsgText:WStrtPos:8) = Proc_D
     C                   EVAL      WScnFlg = 'Y'
     C                   ELSE
     C                   EVAL      WScnFlg = 'N'
     C                   ENDIF
     C                   ENDDO
 
      ** Send a break message to an interactive user by calling SCC4305
 
     C                   EVAL      PProcType = 'S'
     C                   EVAL      PJobName  = WJobname
     C                   EVAL      PUser     = *BLANKS
     C                   EVAL      PJobNum   = *BLANKS
     C                   EVAL      PMsgText  = WMsgText
     C                   EXSR      SRSCC4305
 
     C                   ENDIF
 
     C                   READ      SCACJBPX                               01
     C                   ENDDO
 
     C                   CLOSE     SCACJBPX
 
      ** Send program message to SC24X7Q to an interactive
      ** user in Main System
 
     C                   IF        PProcType = 'S'
     C                   EVAL      WCommand2 = WCmdArr(9) + WCmdArr(10)
     C                   MOVEA     WMsgTxt(4)    WCmd2
     C                   EVAL      PCMD = WCommand2
     C                   EVAL      PCmdLen = WCmdLenArr(9) + WCmdLenArr(10)
     C                   EXSR      SRQCMD
     C                   ENDIF
 
     C                   ENDIF
 
      ** Move 'G' to Cutover Phase in dataarea SCREOP
 
     C     *LOCK         IN        SCREOP
     C                   EVAL      S4PHAS = 'G'
     C                   OUT       SCREOP
 
     C                   EXSR      SRGPhase
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGPhase - 'G' Phase of Cutover                               *
      *                                                               *
      * Called by: SRMainProc, SRFPhase                               *
      *                                                               *
      * Calls: SRHPhase, *PSSR                                        *
      *                                                               *
      *****************************************************************
     C     SRGPhase      BEGSR
 
      ** Switch remotely connected MQ series queues over to the message queues
      ** of the main system
 
     C                   CALL      'SCC004307'                          03
     C                   PARM      ' '           PSwOvrMode
 
     C                   IF        *INU7 = True and *INU8 = True or
     C                             ErrInPgm = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  =  004
     C                   EVAL      DBFILE =  'SCC4307'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Move 'H' to Cutover Phase in dataarea SCREOP
 
     C     *LOCK         IN        SCREOP
     C                   EVAL      S4PHAS = 'H'
     C                   OUT       SCREOP
 
     C                   EXSR      SRHPhase
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHPhase - 'H' Phase of Cutover                               *
      *                                                               *
      * Called by: SRMainProc, SRGPhase                               *
      *                                                               *
      * Calls: SRQCMD, SRIJPhase, *PSSR                               *
      *                                                               *
      *****************************************************************
     C     SRHPhase      BEGSR
 
      ** Call SC004311 if re-open option is '2' or '3',
      ** clear the API log file if re-open option is '4' or '5'
 
     C                   SELECT
     C                   WHEN      S1REOP = '2' or S1REOP = '3'
 
     C                   CALL      'SC004311'                           03
     C                   PARM      ' '           PSwOvrMode
 
     C                   IF        *INU7 = True and *INU8 = True or
     C                             ErrInPgm = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  =  005
     C                   EVAL      DBFILE =  'SC4311'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Send program message to SC24X7Q copying API Log
      ** to API MQ Series Msg Queue
 
     C                   EVAL      WCommand2 = WCmdArr(9) + WCmdArr(10)
     C                   MOVEA     WMsgTxt(5)    WCmd2
     C                   MOVEA     WMsgTxt(2)    WCmd3
     C                   EVAL      PCMD = WCommand2
     C                   EVAL      PCmdLen = WCmdLenArr(9) + WCmdLenArr(10)
     C                   EXSR      SRQCMD
 
     C                   WHEN      S1REOP = '4' or S1REOP = '5'
 
      ** Clear the API log file  APILOGPD and APVLOGPD
 
     C                   EVAL      PCmd    = WCmdArr(1)
     C                   Z-ADD     WCmdLenArr(1) PCmdLen
     C                   EXSR      SRQCMD
 
     C                   EVAL      PCmd    = WCmdArr(2)
     C                   Z-ADD     WCmdLenArr(2) PCmdLen
     C                   EXSR      SRQCMD
 
      ** Send program message to SC24X7Q when clearing API log files
 
     C                   EVAL      WCommand2 = WCmdArr(9) + WCmdArr(10)
     C                   MOVEA     WMsgTxt(6)    WCmd2
     C                   EVAL      PCMD = WCommand2
     C                   EVAL      PCmdLen = WCmdLenArr(9) + WCmdLenArr(10)
     C                   EXSR      SRQCMD
 
     C                   ENDSL
 
      ** Move 'I' to Cutover Phase in dataarea SCREOP
 
     C     *LOCK         IN        SCREOP
     C                   EVAL      S4PHAS = 'I'
     C                   OUT       SCREOP
 
     C                   EXSR      SRIJPhase
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRIJPhase - 'I' and 'J' Phase of Cutover                      *
      *                                                               *
      * Called by: SRMainProc, SRHPhase                               *
      *                                                               *
      * Calls: SRQCMD                                                 *
      *                                                               *
      *****************************************************************
     C     SRIJPhase     BEGSR
 
      ** Call SCC4341 if re-open option is '2' or '4'
 
     C                   IF        S1REOP = '2' or S1REOP = '4'
 
      ** Restore contents of DBIC over the support system.
 
     C                   EVAL      PCmd    = WCmdArr(3) + WCmdArr(11)
     C                   EVAL      PCmdLen = WCmdLenArr(3) + WCmdLenArr(11)
     C                   EXSR      SRQCMD
 
     C                   ELSE
 
      ** End API Background Job in support system.
 
     C                   EVAL      PCmd    = WCmdArr(4) + WCmdArr(11)
     C                   EVAL      PCmdLen = WCmdLenArr(4) + WCmdLenArr(11)
     C                   EXSR      SRQCMD
 
      ** Send program message to SC24X7Q when ending API
      ** Background jobs in supporty system.
 
     C     WCmdArr(9)    CAT       WCmdArr(10)   WCommand2
     C                   MOVEA     WMsgTxt(7)    WCmd2
     C                   EVAL      PCMD = WCommand2
     C                   EVAL      PCmdLen = WCmdLenArr(9) + WCmdLenArr(10)
     C                   EXSR      SRQCMD
 
      ** Move 'Z' to Cutover Phase in dataarea SCREOP
      ** Move *BLANKS to reopen started in dataarea SCREOP
 
     C     *LOCK         IN        SCREOP
     C                   EVAL      S4STRT = *BLANKS
     C                   EVAL      S4PHAS = 'Z'
     C                   OUT       SCREOP
 
      ** Support to Main Transition completed succesfully
 
     C                   EVAL      WCommand2 = WCmdArr(9) + WCmdArr(10)
     C                   MOVEA     WMsgTxt(10)   WCmd2
     C                   EVAL      PCMD = WCommand2
     C                   EVAL      PCmdLen = WCmdLenArr(9) + WCmdLenArr(10)
     C                   EXSR      SRQCMD
 
     C                   ENDIF
 
     C                   EXSR      SRENDP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSCC4303 - Call to program SCC4303                           *
      *                                                               *
      * Called by: SRMainProc, SRFPhase                               *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     SRSCC4303     BEGSR
 
      ** Determine all interactive users still connected to the system
 
     C                   CALL      'SCC004303'                          03
     C                   PARM                    PSysPref
 
     C                   IF        *INU7 = True and *INU8 = True or
     C                             ErrInPgm = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  =  006
     C                   EVAL      DBFILE =  'SCC4303'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSCC4305 - Call to program SCC4305                           *
      *                                                               *
      * Called by: SRMainProc, SRFPhase                               *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     SRSCC4305     BEGSR
 
      ** Send a break message to an interactive session connected to the system or
      ** cancel an interactive session connected to the system.
 
     C                   CALL      'SCC004305'                          03
     C                   PARM                    PProcType
     C                   PARM                    PJobName
     C                   PARM                    PUser
     C                   PARM                    PJobNum
     C                   PARM                    PMsgText
 
     C                   IF        *INU7 = True and *INU8 = True or
     C                             ErrInPgm = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  =  007
     C                   EVAL      DBFILE =  'SCC4305'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetNxtMsg - Get next message subroutine                     *
      *                                                               *
      * Called by: SRMainProc                                         *
      *                                                               *
      * Calls: SRCvtTime, *PSSR                                       *
      *                                                               *
      *****************************************************************
     C     SRGetNxtMsg   BEGSR
 
      ** Initialise 'time of last message' to 'time of next message'
      ** Initialise 'type of last message' to 'type of next message'
 
     C     *LOCK         IN        SCREOP
     C                   EVAL      S4TMLM = S4TMNM
     C                   EVAL      S4TPLM = S4TPNM
 
     C                   IF        S4TPLM = *BLANKS
 
     C                   IF        S1REOP = '2' or S1REOP = '3'
     C                   EVAL      KMsgType = 'V'
     C                   EVAL      WFirstMsg = 'V'
     C                   ELSE
     C                   EVAL      KMsgType = 'W'
     C                   EVAL      WFirstMsg = 'W'
     C                   ENDIF
 
     C     KMsgType      CHAIN     SCSYSTL1                           02
 
     C                   ELSE
 
     C                   EVAL      KMsgType = S4TPLM
     C                   EVAL      KMsgTime = S4TIME
     C                   EVAL      KLangCde = *BLANKS
     C                   MOVEL     KMsgTime      WMsgTime
 
     C     Keylist2      SETGT     SCSYSTL1                           02
 
     C                   IF        NoRecFnd = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  =  008
     C                   EVAL      DBFILE =  'SCSYSTL1'
     C                   EVAL      DBKEY  =  KMsgType + WMsgTime + KLangCde
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      KMsgType = S4TPLM
     C                   EVAL      KMsgTime = *ZERO
     C                   EVAL      KLangCde = *BLANKS
 
     C     KMsgType      READE     SCSYSTL1                               02
 
     C                   ENDIF
 
     C                   IF        NoRecFnd  = True
 
     C                   EVAL      S4TPNM = 'X'
 
     C                   TIME                    WSysTime
 
      ** Convert System time (WSysTime) to seconds
 
     C                   MOVE      WSysTime      DSTimeVar
     C                   EVAL      WCvtTyp = '1'
     C                   EXSR      SRCvtTime
     C                   EVAL      WSysSecs = WSecTot
 
      ** Convert S4TIME to seconds
 
     C                   MOVE      S4TIME        DSTimeVar2
     C                   EVAL      WCvtTyp = '2'
     C                   EXSR      SRCvtTime
     C                   EVAL      WS4Time = WSecTot
 
     C                   EVAL      WS4TMNM = WSysSecs + WS4TIME
 
      ** Convert WS4TMNM (SSSSS) to S4TMNM (HH:MM:SS)
 
     C                   EVAL      WSecTot = WS4TMNM
     C                   EVAL      WCvtTyp = '3'
     C                   EXSR      SRCvtTime
     C                   MOVE      DSTimeVar     S4TMNM
 
     C                   EVAL      S4TIME = *ZERO
 
     C                   ELSE
 
     C                   EVAL      S4TPNM = T1MTYP
 
     C                   IF        S4TPLM = *BLANKS
     C                   EVAL      S4TMNM = WSysTime
     C                   ELSE
 
     C                   IF        S4TPLM = S4TPNM
 
      ** Convert S4TIME to seconds
 
     C                   MOVE      S4TIME        DSTimeVar2
     C                   EVAL      WCvtTyp = '2'
     C                   EXSR      SRCvtTime
     C                   EVAL      WS4Time = WSecTot
 
      ** Convert T1MTIM to seconds
 
     C                   MOVE      T1MTIM        DSTimeVar2
     C                   EVAL      WCvtTyp = '2'
     C                   EXSR      SRCvtTime
     C                   EVAL      WT1MTIM = WSecTot
     C
     C                   EVAL      WDuration = WS4TIME - WT1MTIM
 
     C                   ELSE
 
      ** Convert S4TIME to seconds
 
     C                   MOVE      S4TIME        DSTimeVar2
     C                   EVAL      WCvtTyp = '2'
     C                   EXSR      SRCvtTime
     C                   EVAL      WS4Time = WSecTot
 
     C                   EVAL      WDuration = WS4TIME
 
     C                   ENDIF
 
      ** Convert System time (WSysTime) to seconds
 
     C                   MOVE      WSysTime      DSTimeVar
     C                   EVAL      WCvtTyp = '1'
     C                   EXSR      SRCvtTime
     C                   EVAL      WSysSecs = WSecTot
 
      ** Add WDuration to WSysSecs (Duration + System Time)
      ** Convert WS4TMNM (SSSSS) to S4TMNM (HH:MM:SS)
 
     C                   EVAL      WS4TMNM = WSysSecs + WDuration
     C                   EVAL      WSecTot = WS4TMNM
     C                   EVAL      WCvtTyp = '3'
     C                   EXSR      SRCvtTime
     C                   MOVE      DSTimeVar     S4TMNM
 
     C                   ENDIF
 
     C                   EVAL      S4TIME = T1MTIM
 
     C                   ENDIF
 
     C                   OUT       SCREOP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAOUser - Call to program AOUSERR0                           *
      *                                                               *
      * Called by: SRMainProc, SRFPhase                               *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     SRAOUser      BEGSR
 
      ** Access user file to get the language code for the user
 
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      WUser         PUsrProf
     C     MUSER         PARM      MUSER         DSSDY
 
     C                   IF        @RtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  =  009
     C                   EVAL      DBFILE =  'MUSERDD'
     C                   EVAL      DBKEY  =  WUser
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WUserLang = MULT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZDATE2 - Format a date for output                           *
      *                                                               *
      * Called by: SRMainProc                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRZDATE2      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDayNum
     C                   PARM                    BJDFIN
     C                   PARM                    PDate
     C                   PARM                    PDateAlp
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRQCMD   - Call QCMDEXC                                       *
      *                                                               *
      * Called by: SRMainProc, SRHPhase, SRIJPhase                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRQCMD        BEGSR
 
      ** Scan PCmd text for 'XXXLIB'
 
     C                   EVAL      WLib  = 'aaXLIB'
     C                   EVAL      WScnFlg = 'Y'
     C                   DOW       WScnFlg = 'Y'
     C     WLib          SCAN      PCmd          WStrtPos
     C                   IF        WStrtPos > 0
     C                   EVAL      %SUBST(PCmd:WStrtPos:2) = S1SUPP
     C                   EVAL      WScnFlg = 'Y'
     C                   ELSE
     C                   EVAL      WScnFlg = 'N'
     C                   ENDIF
     C                   ENDDO
 
     C                   CALL      'QCMDEXC'                            03
     C                   PARM                    PCmd
     C                   PARM                    PCmdLen
 
     C                   IF        ErrInPgm = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  =  010
     C                   EVAL      DBFILE =  'QCMDEXC'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCvtTime - Convert Time                                      *
      *                                                               *
      * Called by: SRGetNxtMsg                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRCvtTime     BEGSR
 
     C                   SELECT
 
      ** Convert HH:MM:SS to SSSSS
 
     C                   WHEN      WCvtTyp = '1'
     c                   EVAL      WSec1 = WHours * 3600
     C                   EVAL      WSec2 = WMinute * 60
     C                   EVAL      WSecTot = WSec1 + WSec2 + WSecond
 
      ** Convert MMM:SS to SSSSS
 
     C                   WHEN      WCvtTyp = '2'
     C                   EVAL      WSec1 = WMinute2 * 60
     C                   EVAL      WSecTot = WSec1 + WSecond2
 
      ** Convert SSSSS to HH:MM:SS
 
     C                   WHEN      WCvtTyp = '3'
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
      * SREndP   - End Program                                        *
      *                                                               *
      * Called by: Main Processing, SRMainProc                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SREndP        BEGSR
 
     C                   EVAL      *INLR = True
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Retrieve dataarea SC24X7 and SCREOP
 
     C                   IN        SC24X7
     C                   IN        SCREOP
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SC004340'
     C                   OUT       LDA
 
      ** Obtain records from SDBANKPD
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '        '    @RtCd
     C                   PARM      '*FIRST  '    @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        @RtCd <> *BLANK
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  =  011
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  @Optn
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
      ** Key list to chain to LF/SCSYSTL1
 
     C     Keylist1      KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KMsgTime
     C                   KFLD                    KLangCde
 
      ** Partial key list to chain to LF/SCSYSTL1
 
     C     Keylist2      KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KMsgTime
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** WCmdArr
CLRPFM APILOGPD
CLRPFM APVLOGPD
SBMJOB CMD(CALL PGM(SCC004341)) JOB(RSTDBICSUP) JOBQ(MCOBQ) LOG(4 0 *SECLVL) LOGCLPGM(*YES)
SBMJOB CMD(CALL PGM(SCC004342)) JOB(ENDAPIJOB) JOBQ(MCOBQ) LOG(4 0 *SECLVL) LOGCLPGM(*YES)
CLRMSGQ MSGQ(aaXLIB/MOPERQ)
CLRMSGQ MSGQ(aaXLIB/MRUNQ)
CLRMSGQ MSGQ(aaXLIB/MSTATUS)
CLRMSGQ MSGQ(aaXLIB/MSPECIAL)
SNDMSG MSG('SC004340 -
                                                                                  ') TOMSGQ(SC24X7Q)
 USER(*JOBD) JOBD(MBATCH) OUTQ(*JOBD) INLLIBL(*JOBD)
** WCmdLenArr
0015
0015
0100
0100
0027
0026
0028
0029
0100
0100
0100
** WMsgTxt
Switchover from "Support" to "Main" System message sent to users in Support
System.
Users connected in Support System are cancelled.
''Completion of Transition'' message sent to users in Main System.
Contents of API log file now copied into the MQ Series message queue of Main
API Log Files are now cleared.
API Background jobs in Support System has been ended.
Initialisation for Data Replication has been completed.
Data Replication has been started.
"Support" to "Main" Transition for Reopen processing completed successfully.
