     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Main to support system trans monitor')
/*OVR *: OVRDBF FILE(SCACJBPX) TOFILE(SCACJBPD)                     : *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC004301 - 'Main' to 'Support' System Transition Monitor     *
      *                                                               *
      *  Function:  This module will monitor the transition activity  *
      *             from the 'Main' system to the 'Support' system.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. TDA035             Date 02Apr04               *
      *                 CSC023             Date 28Jan04               *
      *                 CSF002             Date 11Aug03               *
      *                 CAAA02             Date 16Jul03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CSC023 - SBMJOB output queue must be *JOBD.                  *
      *  CSF002 - Global Processing.                                  *
      *           Remove the command which sets up SFC0600 as the     *
      *           program to be called when Attention Key is pressed  *
      *           since SFC0600 is made redundant already.            *
      *  CAAA02 - Remove use of INVITE keyword to enable WebFacing    *
      *           to process screens. Recompile only.                 *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    21         INVITE keyword in SC004301DF active             *
      *    22         Subfile Display Indicator                       *
      *    23         Subfile Display Control Indicator               *
      *    24         Subfile Clear Indicator                         *
      *    70         Chain SCSYSTL1                                  *
      *    71         Read SCACJBPX                                   *
      *    72         Write to subfile record format                  *
      *    73         Transition in progress                          *
      *    74         {*DATE*} Found                                  *
      *    75         Error in calling program                        *
      *    U7         Database Error                                  *
      *    U8         Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SREND   - End Program                                        *
      *  SRDISP  - Display Screen                                     *
      *  SRRSTD  - Write records in subfile when exception/error      *
      *  SRTime  - Determine system time                              *
      *  SRLOAD1 - Load subfile records                               *
      *  SRRtvTxt - Retrieve Text                                     *
      *  SRLOAD2 - Load subfile records                               *
      *  SRLOAD3 - Load subfile records                               *
      *  SRINIT  - Program Initialisation                             *
      *  SRQCMD  - Subroutine to 'QCMDEXC'                            *
      * *INZSR - Initialise                                           *
      * *PSSR - Error processing                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      ** Processing Date Switch Message File
     FSCSYSTL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Subsystem Jobs in System File
     FSCACJBPX  IF   E             DISK    INFSR(*PSSR) USROPN
 
      ** Display File for Transition Monitor
     FSC004301DFCF   E             WORKSTN
     F                                     INFDS(INFFDK)
     F                                     INFSR(*PSSR)
     F                                     SFILE(SC004301S0:#0USRC)
 
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Dummy Data Structure used by Access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Dummy Data Structure used by Access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Status Code
     D INFFDK          DS
     D  WWSTUS           *STATUS
 
      ** SF Users File
     D MUSER         E DS                  EXTNAME(MUSERDD)
 
      ** Subsystem jobs connected to the system
     D SCACJB          DS           132
     D  W@JOB                  4     13
     D  W@USR                 17     26
     D  W@NUM                 30     35
     D  WTYPE                 39     43
     D  W@FNC                 68     81
 
      ** Main to Support System Transition Status Dataarea
     D SCMAIN        E DS                  EXTNAME(SCMAIN) DTAARA(SCMAIN)
 
      ** Switchable Features Description
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SCLCD        E                     EXTFLD(LCD)
 
      ** 24x7 Status Dataarea
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Bank Details ICD File
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D WCommand        DS           200
     D  WCmd1                 15     22
     D  WCmd2                 21     29
     D  WCmd3                 37     46
 
     D WCommand1       DS           200
     D  WCmd4                  5     13
 
     D WCommand2       DS           200
     D  WCmd5                 24    100
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D*AUS025***       S              1                                                       CSF002
     D*CAAA01***       S              1                                                       CSF002
 
     ** Parameter Variables
     D PActCode        S              1
     D PADate          S              7
     D PCMD            S            200
     D PCMDLEN         S             15  5
     D PDayNo          S              5  0
     D PDatFmt         S              1
     D PDate           S              6  0
     D PJobName        S             10
     D PMessage        S            500
     D PMsgId          S              7A
     D PMsgNm          S             10A
     D PMsgTxt         S             80A
     D PNumber         S              6
     D POPTN           S              7
     D PPType          S              1
     D PRTCD           S              7
     D PSARD           S              6
     D PSwitchMode     S              1
     D PSubsyst        S              2
     D PUser           S             10
     D PUSRP           S             10
 
      ** Working Variables
     D WCode           S              1
     D WDfltMsg        S            500
     D WFound          S              1
     D WkDate          S              8
     D WMsg            S              1
     D WMSG1           S             35
     D WMSG2           S             35
     D WMSG3           S             35
     D WNUM1           S              6  0
     D WPos            S              3  0
     D WQcmd1          S            100    DIM(3) CTDATA PERRCD(1)
     D WQcmd2          S            100    DIM(2) CTDATA PERRCD(1)
     D WMsgTxt         S            100    DIM(3) CTDATA PERRCD(1)
     D WRefr           S              1
     D WSysTime        S              6  0
     D WTime           S              5  0
     D @RUN            S              1
 
      ** Counter for Subfile
     D Z               S              2  0
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Perform Initialisation
 
     C                   EXSR      SRINIT
 
      ** Do loop while Status in SCMAIN is not 'C' and Cutover Phase is not
      ** 'Z'
 
     C                   DOW       S2STAT <> 'C'
     C                             AND S2PHAS <> 'Z'
 
      ** Cutover Phase is not 'O'
 
     C                   IF        S2PHAS <> 'O'
     C                   EXSR      SRLOAD1
     C                   ELSE
 
      ** Cutover Phase is 'O'
 
     C                   EXSR      SRLOAD2
     C                   ENDIF
 
      ** Retrieve dataarea SCMAIN
 
     C                   IN        SCMAIN
 
     C                   ENDDO
 
     C                   IF        S2STAT = 'C'
     C                   EVAL      PActCode = 'C'
     C                   END
 
     C                   EXSR      SREND
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREND - Subroutine to End Program                             *
      *                                                               *
      * Called by: Main Subroutine                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SREND         BEGSR
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDISP - Display Screen                                       *
      *                                                               *
      * Called by: SRLOAD1, SRLOAD2,                                  *
      *                                                               *
      * Calls: SRRSTD, SRTIME, SRRtvTxt                               *
      *                                                               *
      *****************************************************************
     C     SRDISP        BEGSR
 
     C                   IF        *IN23 = *OFF
     C                   MOVEA     '11'          *IN(22)
     C                   ENDIF
 
      ** No Job to display on subfile
 
     C                   IF        Z = 0
     C                             AND *IN73 = *OFF
     C                   EVAL      *IN21 = *ON
     C                   MOVEA     '11'          *IN(23)
 
     C                   EVAL      PMsgId = 'SCC0037'
     C                   EXSR      SRRtvTxt
     C                   EVAL      #0MSG1 = PMsgTxt
 
     C                   IF        WWSTUS = 0
     C                   WRITE     SC004301F0                           72
     C                   WRITE     SC004301F1                           72
     C                   EXSR      SRTIME
     C                   WRITE     SC004301C0                           72
     C                   IF        *IN72 = '1'
     C                             OR  WWSTUS <> 0
     C                   EXSR      SRRSTD
     C                   ENDIF
     C                   ELSE
     C                   EXSR      SRRSTD
     C                   ENDIF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN24 = *OFF
     C                   ENDIF
 
      ** Transition Progress on subfile
 
     C                   IF        *IN73 = *ON
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN24 = *ON
 
     C                   EVAL      PMsgId = 'SCC0038'
     C                   EXSR      SRRtvTxt
     C                   EVAL      #0MSG1 = PMsgTxt
 
     C                   IF        WWSTUS = 0
     C                   WRITE     SC004301F0                           72
     C                   WRITE     SC004301F1                           72
     C                   EXSR      SRTIME
     C                   WRITE     SC004301C0                           72
     C                   IF        *IN72 = '1'
     C                             OR  WWSTUS <> 0
     C                   EXSR      SRRSTD
     C                   ENDIF
     C                   ELSE
     C                   EXSR      SRRSTD
     C                   ENDIF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN73 = *OFF
     C                   ENDIF
 
      ** Display records from SCACJBPX to subfile
 
     C                   IF        z > 0
 
     C                   MOVEA     '111'         *IN(21)
     C                   EVAL      *IN24 = *OFF
     C                   MOVEA     '00'          *IN(36)
 
     C                   IF        WWSTUS = 0
     C                   WRITE     SC004301F0                           72
     C                   EXSR      SRTIME
     C                   WRITE     SC004301C0                           72
     C                   IF        *IN72 = '1'
     C                             OR  WWSTUS <> 0
     C                   EXSR      SRRSTD
     C                   ENDIF
     C                   ELSE
     C                   EXSR      SRRSTD
     C                   ENDIF
     C                   EVAL      *IN21 = *OFF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRSTD - Subroutine to write records in subfile when          *
      *          exception/error occur                                *
      *                                                               *
      * Called by: SRDISP, SRLOAD1, SRLOAD2                           *
      *                                                               *
      * Calls: SRTIME                                                 *
      *                                                               *
      *****************************************************************
     C     SRRSTD        BEGSR
 
     C                   EVAL      WWSTUS = 0
     C                   EVAL      *IN72 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   MOVEA     '11'          *IN(22)
     C                   READ      SC004301C0
     C                   EVAL      *IN21 = *ON
     C                   WRITE     SC004301F0                           72
     C                   EXSR      SRTIME
     C                   WRITE     SC004301C0                           72
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTIME - Determine System time                                *
      *                                                               *
      * Called by: SRDISP, SRRSTD                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRTIME        BEGSR
 
      ** Determine system time
 
     C                   Z-ADD     0             #0TIME
     C                   TIME                    WSysTime
     C                   EVAL      #0TIME = WSysTime
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLOAD1 - Subroutine to load subfile when Cutover Phase is    *
      *           not 'O'                                             *
      *                                                               *
      * Called by: Main Subroutine                                    *
      *                                                               *
      * Calls: QCMDEXC, SCC004302, SCC004303, SCC004304, SRRSTD,      *
      *        SRRtvTxt, SRDISP                                       *
      *                                                               *
      *****************************************************************
     C     SRLOAD1       BEGSR
 
      ** Set 'Main' to 'Support' System Control Menu
 
     C                   EVAL      WCommand = WQcmd1(1)
     C                   EVAL      WCmd1 = 'SC004302'
     C                   EVAL      PCMD = WCommand
     C                   Z-ADD     32            PCMDLEN
     C                   EXSR      SRQCMD
 
      ** Determine all interactive users still connected in the main system
 
     C                   CALL      'SCC004303'                          75
     C                   PARM      S1MAIN        PSubsyst
 
     C                   IF        (*INU7 = *ON
     C                             AND *INU8 = *ON)
     C                             OR *IN75 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 001
     C                   EVAL      DBFILE = 'SCC4303'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve value from dataarea SCMAIN
 
     C                   IN        SCMAIN
 
     C                   IF        S2STAT = 'C'
     C                   EVAL      PActCode = 'C'
     C                   ELSE
 
      ** Submit COBMSGCTL to send break messages to interactive users
 
     C                   CALL      'SCC004322'
     C                   PARM                    PsJobName
 
      ** Clear Subfile
 
     C                   IF        WWSTUS = 0
     C                   MOVEA     '1111'        *IN(21)
     C                   WRITE     SC004301C0                           72
     C                   IF        *IN72 = '1'
     C                             OR  WWSTUS <> 0
     C                   EVAL      *IN24 = *ON
     C                   EXSR      SRRSTD
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN24 = *ON
     C                   EXSR      SRRSTD
     C                   ENDIF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      #0USRC = 0
     C                   EVAL      #0COUNT = 0
     C                   EVAL      Z = 0
 
      ** Read records in PF/SCACJBPX
 
     C                   OPEN      SCACJBPX
     C     1             SETLL     SCACJBPX
     C                   READ      SCACJBPX                               71
 
     C                   DOW       *IN71 = *OFF
 
      ** Check whether user is an interactive session
 
     C                   IF        WTYPE = 'INTER'
     C                   MOVEL     W@NUM         WNUM1
 
      ** Do not display current job
 
     C                   IF        W@JOB <> PsJobName
     C                             OR W@USR <> PsUser
     C                             OR WNUM1 <> PsJobNo
     C                   ADD       1             Z
     C                   ADD       1             #0COUNT
     C                   IF        Z < 13
     C                   ADD       1             #0USRC
     C                   EVAL      #0JOB1 = W@JOB
     C                   EVAL      #0USR1 = W@USR
     C                   EVAL      #0NUM1 = WNUM1
     C                   EVAL      #0FNC1 = W@FNC
     C                   IF        WWSTUS = 0
     C                   WRITE     SC004301S0                           72
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SCACJBPX                               71
     C                   ENDDO
     C                   CLOSE     SCACJBPX
 
      ** Determine time/type of messages from SCMAIN
 
     C                   IN        SCMAIN
 
      ** Display Time of Last/Next Message
 
     C                   EVAL      #0TIM1 = S2TMLM
     C                   EVAL      #0TIM2 = S2TMNM
 
      ** Display Type Of Last Message
 
     C                   SELECT
 
     C                   WHEN      S2TPLM = 'C'
     C                   EVAL      PMsgId = 'SCC0032'
     C                   EVAL      WCode = 'A'
 
     C                   WHEN      S2TPLM = 'S'
     C                   EVAL      PMsgId = 'SCC0033'
     C                   EVAL      WCode = 'A'
 
     C                   WHEN      S2TPLM = 'O'
     C                   EVAL      PMsgId = 'SCC0034'
     C                   EVAL      WCode = 'A'
 
     C                   ENDSL
 
     C                   IF        PMsgId <> *BLANKS
     C                             AND WCode = 'A'
     C                   EXSR      SRRtvTxt
     C                   EVAL      #0TYP1 = PMsgTxt
     C                   ENDIF
 
      ** Display Type Of Next Message
 
     C                   SELECT
 
     C                   WHEN      S2TPNM = 'C'
     C                   EVAL      PMsgId = 'SCC0032'
     C                   EVAL      WCode = 'B'
 
     C                   WHEN      S2TPNM = 'S'
     C                   EVAL      PMsgId = 'SCC0033'
     C                   EVAL      WCode = 'B'
 
     C                   WHEN      S2TPNM = 'O'
     C                   EVAL      PMsgId = 'SCC0034'
     C                   EVAL      WCode = 'B'
 
     C                   ENDSL
 
     C                   IF        PMsgId <> *BLANK
     C                             AND WCode = 'B'
     C                   EXSR      SRRtvTxt
     C                   EVAL      #0TYP2 = PMsgTxt
     C                   ENDIF
 
      ** Display Status of Transition
 
     C                   IF        S2STAT = 'H'
     C                   EVAL      PMsgId = 'SCC0035'
     C                   EVAL      WCode = 'C'
     C                   ELSE
     C                   EVAL      PMsgId = 'SCC0036'
     C                   EVAL      WCode = 'C'
     C                   ENDIF
 
     C                   IF        PMsgId <> *BLANK
     C                             AND WCode = 'C'
     C                   EXSR      SRRtvTxt
     C                   EVAL      #0STAT = PMsgTxt
     C                   ENDIF
 
      ** Display interactive sessions in monitor screen
 
     C                   EXSR      SRDISP
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvTxt - Retrieve Text                                      *
      *                                                               *
      * Called by: SRLOAD1, SRDISP                                    *
      *                                                               *
      * Calls: SDRTVTXT                                               *
      *                                                               *
      *****************************************************************
     C     SRRtvTxt      BEGSR
     C                   CALL      'SDRTVTXT'
     C                   PARM                    PMsgId
     C                   PARM      'SDUSRMSG'    PMsgNm
     C                   PARM      *BLANK        PMsgTxt
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLOAD2 - Subroutine to load subfile when Cutover Phase is    *
      *           'O'                                                 *
      *                                                               *
      * Called by: Main Subroutine                                    *
      *                                                               *
      * Calls: SFC4460, SFC0600, SCC004303, SRRSTD, SCC004305,        *
      *        SRDISP, SCC004307, SCC004306, SCC004309, SRLOAD3,      *
      *        QCMDEXC                                                *
      *                                                               *
      *****************************************************************
     C     SRLOAD2       BEGSR
 
      ** Check if session manager is present
 
     C**********         IF        AUS025 = 'Y'                                               CSF002
     C**********         CALL      'SCC004318'                          75                    CSF002
     C**********         PARM                    AUS025                                       CSF002
     C**********         IF        (*INU7 = *ON                                               CSF002
     C**********                   AND *INU8 = *ON)                                           CSF002
     C**********                   OR *IN75 = *ON                                             CSF002
     C******LOCK         IN        LDA                                                        CSF002
     C**********         EVAL      DBASE = 002                                                CSF002
     C**********         EVAL      DBFILE = 'SCC4318'                                         CSF002
     C**********         EVAL      DBKEY = '*CALL'                                            CSF002
     C**********         OUT       LDA                                                        CSF002
     C**********         EXSR      *PSSR                                                      CSF002
     C**********         ENDIF                                                                CSF002
 
     C**********         ELSE                                                                 CSF002
     C****************************************************************                        CSF002
     C**********         EVAL      WCommand = WQcmd1(1)                                       CSF002
     C**********         EVAL      WCmd1 = 'SFC0600'                                          CSF002
     C**********         EVAL      PCMD = WCommand                                            CSF002
     C**********         Z-ADD     32            PCMDLEN                                      CSF002
     C**********         EXSR      SRQCMD                                                     CSF002
      **********                                                                              CSF002
     C**********         ENDIF                                                                CSF002
 
      ** Determine all interactive users still connected in the main system
 
     C                   CALL      'SCC004303'                          75
     C                   PARM      S1MAIN        PSubsyst
     C                   IF        (*INU7 = *ON
     C                             AND *INU8 = *ON)
     C                             OR *IN75 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 003
     C                   EVAL      DBFILE = 'SCC4303'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C
 
      ** Clear Subfile
 
     C                   IF        WWSTUS = 0
     C                   MOVEA     '1111'        *IN(21)
     C                   WRITE     SC004301C0
     C                   IF        *IN72 = '1'
     C                             OR  WWSTUS <> 0
     C                   EVAL      *IN24 = *ON
     C                   EXSR      SRRSTD
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN24 = *ON
     C                   EXSR      SRRSTD
     C                   ENDIF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      #0USRC = 0
     C                   EVAL      #0COUNT = 0
     C                   EVAL      Z = 0
 
      ** Read records in SCACJBPX
 
     C                   OPEN      SCACJBPX
     C     1             SETLL     SCACJBPX
     C                   READ      SCACJBPX                               71
 
     C                   DOW       *IN71 = *OFF
     C                   IF        WTYPE = 'INTER'
     C                   MOVEL     W@NUM         WNUM1
 
      ** Cancel interactive sessions connected to the 'Main' system
 
     C                   IF        PsUser <> W@USR
     C                             OR PsJobName <> W@JOB
     C                             OR PsJobNo <> WNUM1
     C                   CALL      'SCC004305'                          75
     C                   PARM      'E'           PPType
     C                   PARM      W@JOB         PJobName
     C                   PARM      W@USR         PUser
     C                   PARM      W@NUM         PNumber
     C                   PARM      *BLANKS       PMessage
 
     C                   IF        (*INU7 = *ON
     C                             AND *INU8 = *ON)
     C                             OR *IN75 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 004
     C                   EVAL      DBFILE = 'SCC4305'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SCACJBPX                               71
     C                   ENDDO
     C                   CLOSE     SCACJBPX
 
      ** Send program message to SC24X7Q when cancelling interactive sessions
 
     C                   IF        PPType = 'E'
     C                   EVAL      WCommand2 = WQcmd2(1) + WQcmd2(2)
     C                   MOVEA     WMsgTxt(1)    WCmd5
     C                   EVAL      PCMD = WCommand2
     C                   Z-ADD     200           PCMDLEN
     C                   EXSR      SRQCMD
     C                   ENDIF
 
      ** Seton indicator to determine display of message
 
     C                   IF        *IN71 = *ON
     C                   EVAL      *IN73 = *ON
     C                   ENDIF
 
      ** Display interactive sessions in monitor screen
 
     C                   EXSR      SRDISP
 
      ** Switch MQ series queues from 'Main' to 'Support' system
 
     C                   CALL      'SCC004307'                          75
     C                   PARM      'S'           PSwitchMode
 
     C                   IF        (*INU7 = *ON
     C                             AND *INU8 = *ON)
     C                             OR *IN75 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 005
     C                   EVAL      DBFILE = 'SCC4307'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Process 'Journal Drain' Phase
 
     C                   CALL      'SCC004306'                          75
 
     C                   IF        (*INU7 = *ON
     C                             AND *INU8 = *ON)
     C                             OR *IN75 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 006
     C                   EVAL      DBFILE = 'SCC4306'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Start API database servers in the 'support' system
 
     C                   EVAL      WCommand = WQcmd1(2)
     C                   EVAL      WCommand1 = WQcmd1(3)
     C                   EVAL      WCmd2 = 'SCC004309'
     C                   EVAL      WCmd3 = S1SUPP
     C                   EVAL      WCmd4 = 'STRAPIJOB'
     C     WCommand      CAT       WCommand1:1   PCMD
     C                   Z-ADD     200           PCMDLEN
     C                   EXSR      SRQCMD
 
     C     *LOCK         IN        SC24X7
     C                   EVAL      S1MANT = ' '
     C                   OUT       SC24X7
 
     C                   EVAL      WMsg = 'O'
     C     WMsg          CHAIN     SCSYSTL1                           70
     C                   IF        *IN70 = *OFF
     C                   EVAL      WDfltMsg = T1MTXT
     C                   EXSR      SRLOAD3
     C                   ENDIF
 
      ** Change Cutover phase to 'Z'
 
     C     *LOCK         IN        SCMAIN
     C                   EVAL      S2PHAS = 'Z'
     C                   OUT       SCMAIN
 
      ** 'Main' to 'Support' Transition completed successfully
 
     C                   EVAL      WCommand2 = WQcmd2(1) + WQcmd2(2)
     C                   MOVEA     WMsgTxt(3)    WCmd5
     C                   EVAL      PCMD = WCommand2
     C                   Z-ADD     200           PCMDLEN
     C                   EXSR      SRQCMD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLOAD3 - Subroutine to load subfile when partial key 'O'     *
      *           found in LF/SCSYSTL1                                *
      *                                                               *
      * Called by: SRLOAD2                                            *
      *                                                               *
      * Calls: SCC004303, AOUSERR0, SCC004305                         *
      *                                                               *
      *****************************************************************
     C     SRLOAD3       BEGSR
 
      ** Copy spooled file of interactive session in the support system to
      ** SCACJBPX
 
     C                   CALL      'SCC004303'                          75
     C                   PARM      S1SUPP        PSubsyst
     C                   IF        (*INU7 = *ON
     C                             AND *INU8 = *ON)
     C                             OR *IN75 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 007
     C                   EVAL      DBFILE = 'SCC4303'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Read records in SCACJBPX
 
     C                   OPEN      SCACJBPX
     C     1             SETLL     SCACJBPX
     C                   READ      SCACJBPX                               71
 
     C                   DOW       *IN71 = *OFF
 
     C                   IF        WTYPE = 'INTER'
 
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY '       POPTN
     C                   PARM      W@USR         PUSRP
     C     MUSER         PARM      MUSER         DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 008
     C                   EVAL      DBFILE = 'MUSERDD'
     C                   EVAL      DBKEY = W@USR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Chain to LF/SCSYSTL1 using 'O'/'0' and user language to get
      ** 'Message Text'
 
     C     KMsgT         CHAIN     SCSYSTL1                           70
     C                   IF        *IN70 = *OFF
     C                   EVAL      PMessage = T1MTXT
     C                   ELSE
     C                   EVAL      PMessage = WDfltMsg
     C                   ENDIF
 
      ** Scan message text for {*DATE*} and replace it with Processing_Date
 
     C                   EVAL      WkDate = '{*DATE*}'
     C     WkDate        SCAN      PMessage      WPos                     74
     C                   DOW       *IN74 = *ON
     C                   EVAL      %SUBST(PMessage:WPos:8) = PADATE
     C     WkDate        SCAN      PMessage      WPos                     74
     C                   ENDDO
 
      ** Send break message to an interactive session
 
     C                   MOVEL     W@NUM         WNUM1
     C                   IF        PsUser <> W@USR
     C                             OR PsJobName <> W@JOB
     C                             OR WNUM1 <> PsJobNo
     C                   CALL      'SCC004305'                          75
     C                   PARM      'S'           PPType
     C                   PARM      W@JOB         PJobName
     C                   PARM      *BLANKS       PUser
     C                   PARM                    PNumber
     C                   PARM                    PMessage
     C                   IF        (*INU7 = *ON
     C                             AND *INU8 = *ON)
     C                             OR *IN75 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 009
     C                   EVAL      DBFILE = 'SCC4305'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SCACJBPX                               71
     C                   ENDDO
     C                   CLOSE     SCACJBPX
 
      ** Send program message to SC24X7Q when sending break messages
      ** to users in Support System.
 
     C                   IF        PPType = 'S'
     C                   EVAL      WCommand2 = WQcmd2(1) + WQcmd2(2)
     C                   MOVEA     WMsgTxt(2)    WCmd5
     C                   EVAL      PCMD = WCommand2
     C                   Z-ADD     200           PCMDLEN
     C                   EXSR      SRQCMD
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Subroutine to do Program Initialisation              *
      *                                                               *
      * Called by: Main Subroutine                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
 
      ** Initialise all screen fields, indicators and function keys.
 
     C                   EVAL      #0JOB1 = *BLANKS
     C                   EVAL      #0USR1 = *BLANKS
     C                   EVAL      #0NUM1 = 0
     C                   EVAL      #0FNC1 = *BLANKS
     C                   EVAL      #0TIM1 = 0
     C                   EVAL      #0TYP1 = *BLANKS
     C                   EVAL      #0TIM2 = 0
     C                   EVAL      #0TYP2 = *BLANKS
     C                   EVAL      #0STAT = *BLANKS
     C                   EVAL      #0COUNT = 0
 
     C                   MOVEA     '000'         *IN(21)
 
      ** Clear subfile
 
     C                   EVAL      *IN24 = *ON
     C                   WRITE     SC004301C0
     C                   EVAL      *IN24 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRQCMD - Subroutine to 'QCMDEXC'                              *
      *                                                               *
      * Called by: Main Subroutine                                    *
      *                                                               *
      * Calls: SRDISP, SRLOAD1, SRLOAD2, SRLOAD3                      *
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
      * Calls: AOBANKR0, ZDATE2, AOUSERR0, AOSARDR0                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PActCode
 
      ** Retrieve dataarea SCMAIN and SC24X7
 
     C                   IN        SC24X7
     C                   IN        SCMAIN
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SC004301'
     C                   OUT       LDA
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 010
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Convert Processing Date
 
     C                   CALL      'ZDATE2'
     C                   PARM      S1DATE        PDayNo
     C                   PARM      BJDFIN        PDatFmt
     C                   PARM                    PDate
     C                   PARM                    PADate
 
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WSID = PsJobName
     C                   EVAL      #0RUNA = BJMRDT
 
     C     KMsgT         KLIST
     C                   KFLD                    WRefr
     C                   KFLD                    WTime
     C                   KFLD                    MULT
 
     C                   EVAL      Wrefr = 'O'
     C                   EVAL      WTime = 0
 
     C**********         CALL      'AOSARDR0'                                                 CSF002
     C**********         PARM      *BLANKS       PRTCD                                        CSF002
     C**********         PARM      '*VERIFY'     POPTN                                        CSF002
     C**********         PARM      'CAAA01'      PSARD                                        CSF002
     C*****SCSARD        PARM      SCSARD        DSSDY                                        CSF002
      **********                                                                              CSF002
     C**********         IF        PRTCD <> *BLANKS                                           CSF002
     C**********                   AND PRTCD <> '*NRF'                                        CSF002
     C******LOCK         IN        LDA                                                        CSF002
     C**********         EVAL      DBASE = 011                                                CSF002
     C**********         EVAL      DBFILE = 'SCSARDPD'                                        CSF002
     C**********         EVAL      DBKEY = 'CAAA01'                                           CSF002
     C**********         OUT       LDA                                                        CSF002
     C**********         EXSR      *PSSR                                                      CSF002
     C**********         ENDIF                                                                CSF002
      **********                                                                              CSF002
     C**********         IF        PRTCD = *BLANKS                                            CSF002
     C**********         EVAL      CAAA01 = 'Y'                                               CSF002
     C**********         ENDIF                                                                CSF002
      **********                                                                              CSF002
     C**********         IF        CAAA01 = 'Y'                                               CSF002
     C**********         CALL      'AOUSERR0'                                                 CSF002
     C**********         PARM      *BLANKS       PRTCD                                        CSF002
     C**********         PARM      '*KEY'        POPTN                                        CSF002
     C**********         PARM      PsUser        PUSRP                                        CSF002
     C*****MUSER         PARM      MUSER         DSSDY                                        CSF002
      **********                                                                              CSF002
     C**********         IF        PRTCD <> *BLANKS                                           CSF002
     C******LOCK         IN        LDA                                                        CSF002
     C**********         EVAL      DBASE = 012                                                CSF002
     C**********         EVAL      DBFILE = 'MUSERDD'                                         CSF002
     C**********         EVAL      DBKEY = PsUser                                             CSF002
     C**********         OUT       LDA                                                        CSF002
     C**********         EXSR      *PSSR                                                      CSF002
     C**********         ENDIF                                                                CSF002
     C**********         ENDIF                                                                CSF002
      **********                                                                              CSF002
     C**********         EVAL      AUS025 = 'N'                                               CSF002
      **********                                                                              CSF002
     C**********         IF        PCIU <> 'Y'                                                CSF002
     C**********                   AND PCIU <> 'E'                                            CSF002
     C**********         CALL      'AOSARDR0'                                                 CSF002
     C**********         PARM      *BLANKS       PRTCD                                        CSF002
     C**********         PARM      '*VERIFY'     POPTN                                        CSF002
     C**********         PARM      'AUS025'      PSARD                                        CSF002
     C*****SCSARD        PARM      SCSARD        DSSDY                                        CSF002
      **********                                                                              CSF002
     C**********         IF        PRTCD <> *BLANKS                                           CSF002
     C**********                   AND PRTCD <> '*NRF'                                        CSF002
     C******LOCK         IN        LDA                                                        CSF002
     C**********         EVAL      DBASE = 013                                                CSF002
     C**********         EVAL      DBFILE = 'SCSARDPD'                                        CSF002
     C**********         EVAL      DBKEY = 'AUS025'                                           CSF002
     C**********         OUT       LDA                                                        CSF002
     C**********         EXSR      *PSSR                                                      CSF002
     C**********         ENDIF                                                                CSF002
      **********                                                                              CSF002
     C**********         IF        PRTCD = *BLANKS                                            CSF002
     C**********         EVAL      AUS025 = 'Y'                                               CSF002
     C**********         ENDIF                                                                CSF002
      **********                                                                              CSF002
     C**********         ENDIF                                                                CSF002
 
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
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** WQcmd1
SETATNPGM PGM(        ) SET(*ON)
SBMJOB CMD(CALL PGM(         ) PARM(          )) USER(*JOBD) JOBD(MBATCH)
JOB(         ) JOBQ(MCOBQ) LOG(4 0 *SECLVL) LOGCLPGM(*YES) OUTQ(*JOBD) INLLIBL(*JOBD)
** WQcmd2
SNDMSG MSG('SC004301 -
          ') TOMSGQ(SC24X7Q)
** WMsgTxt
Users connected in Main System are cancelled.
''Completion of Transition'' message sent to users in Support system
''Main'' to ''Support'' Transition completed successfully.
