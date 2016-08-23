     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Re-generation of position sett for WTax')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE7608 - Re-Generation of Position Settlement for            *
      *            withholding tax.                                   *
      *                                                               *
      *  Function:  This module provides the input screen for         *
      *             the user selection input of Re-Generation of      *
      *             position settlement for withholding tax.          *
      *                                                               *
      *  Component of: SEC7608 Re-Generation of position settlement   *
      *                for withholding tax.                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR689705           Date 03Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSC023             Date 28Jan04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CPK014             Date 11Oct01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *  AR656294 - HATS issue                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSC023 - SBMJOB output queue must be *JOBD.                  *
      *  CPK014 - Submit jobs with user *JOBD                         *
      *  CSE023 - Treaty Witholding Tax                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Allocations per dividend payment summary report display file
     FSE7608DF  CF   E             WORKSTN
 
      ** Securities details
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
 
      ** Security Events - by Security, Event Type and date
     FSECEO     IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function  of Indicators                                      *
      *                                                               *
      *  01        End of File indicator                              *
      *  10-12     Field Error - highlight screen fields              *
      *  13        F10 Confirm enabled                                *
      *  25        Subfile control                                    *
      *  25        Subfile end                                        *
      *  90-99     Used by standard subroutine                        *
      *  KC        F3 pressed = Exit                                  *
      *  KJ        F10 pressed = Confirm                              *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
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
 
      ** Array for command in QCMDEX
     D*STRARR***       S             80    DIM(2) CTDATA PERRCD(1)                            CSC023
     DSTRARR           S             80    DIM(3) CTDATA PERRCD(1)                            CSC023
 
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for access programs - very long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Fields
     D WScrn           S              1A
     D WDdte           S              5P 0
     D WEvtp           S              2A
     D EEvtp           S                   LIKE(SDET)
     D EDdte           S                   LIKE(SDED)
 
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgD           S             45A
 
      ** Parameters for ZDATE1
     D PDate           S              6A
     D PDaynoOut       S              5P 0
     D ErrorFlag       S              1A
 
      ** Parameters for module AOBANKR0
     D PRtCd           S              7A
     D POptn           S              7A
 
      ** Parameters for QCMDEXC
     D PCmdTxt         DS
     D   PCmdTxt1              1     80
     D   PCmdTxt2             81    160
     D   PParm1               82     91
     D   PParm2               97    101
     D   PParm3              107    108
     D   PCmdTxt3            161    240                                                       CSC023
 
     D PCmdLen         S             15  5
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Initialise.
 
     C                   EXSR      SRInit
 
      ** Process inputs.
 
     C                   EXSR      SRProc
 
      ** Return.
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process inputs                                      *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
 
      ** Before sending the messages to the program message queue,
      ** clear the program message queue.
 
     C                   EXSR      SRClrMsgQ
 
      ** Do while SCREEN : Read details.
 
     C                   DOW       WScrn = 'P'
     C                   EXSR      SRDisp
     C                   IF        *INKC = *ON
     C                   EVAL      WScrn = 'E'
     C                   ELSE
     C                   EXSR      SRVal
 
      ** Submit job.
 
     C                   IF        WScrn = 'S'
     C                   EXSR      SRSbmjob
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
      ** Terminate program.
 
     C                   IF        WScrn = 'E'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialise variables                                *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   CLEAR                   SSECU
     C                   CLEAR                   SDDTE
     C                   CLEAR                   SEVTP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrMsgQ - Initialise variables                             *
      *                                                               *
      *****************************************************************
     C     SRClrMsgQ     BEGSR
 
      ** Before sending the messages to the program message queue,
      ** clear the program message queue.
 
     C                   CALLB     'ZAMSGCLRPG'
     C                   PARM                    PSProcPgm
     C                   PARM                    PSProcMod
     C                   PARM                    PSProcName
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal - Validate details                                     *
      *                                                               *
      *****************************************************************
     C     SRVal         BEGSR
 
      ** Validate details entered.
 
     C                   EXSR      SRValSEcu
     C                   EXSR      SRValDDte
     C                   EXSR      SRValEVtp
 
      ** If no errors, chain to LF/SECEO to see if a record exist for this  .
 
     C                   IF        ((*IN10 = *OFF) AND  (*IN11 = *OFF) AND
     C                             (*IN12 = *OFF))
 
     C     WKey1         CHAIN     SECEO                              01
 
     C                   IF        *IN01
 
     C                   EVAL      *IN10 = *ON
     C                   EVAL      *IN11 = *ON
     C                   EVAL      *IN12 = *ON
     C                   EVAL      PMsgId = 'SEA0434'
     C                   EXSR      SRSndM
 
     C                   ELSE
     C                   EVAL      WScrn = 'S'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSbmjob - Submit Job                                        *
      *                                                               *
      *****************************************************************
     C     SRSbmjob      BEGSR
 
     C                   EVAL      *IN13 = *ON
     C                   MOVEA     '000'         *IN(10)
     C                   EVAL      PMsgId = 'SEA0441'
     C                   EXSR      SRSndM
     C                   WRITE     SE7608C1
     C                   WRITE     SE7608F1                                                 AR656294
     C                   WRITE     SE7608F0
     C**********         WRITE     SE7608F1                                                 AR656294
     C                   READ      SE7608F0                               01
 
     C                   IF        *INKJ = *ON
 
     C                   EXSR      SRCmdStr
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCmdTxt
     C                   PARM      160           PCmdLen
 
     C                   EVAL      *IN13 = *OFF
     C                   EXSR      SRClrMsgQ
     C                   EVAL      PMsgId = 'SEA0435'
     C                   EXSR      SRSndM
     C                   WRITE     SE7608C1
     C                   WRITE     SE7608F1                                                 AR656294
     C                   WRITE     SE7608F0
     C**********         WRITE     SE7608F1                                                 AR656294
     C                   READ      SE7608F0                               01
 
     C                   ENDIF
 
      ** F3 pressed. exit program
 
     C                   IF        *INKC = *ON
     C                   EVAL      WScrn = 'E'
     C                   ELSE
     C                   EVAL      WScrn = 'P'
     C                   EVAL      *IN13 = *OFF
     C                   EXSR      SRInit
 
      ** Clear message subfile.
 
     C                   CALL      'ZA0250'
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Send Message to Screen                              *
      *                                                               *
      *****************************************************************
     C     SRSndM        BEGSR
 
      ** Call screen message handler.
 
     C                   CALLB     'ZAMSGTOSCN'
     C                   PARM                    PMsgF
     C                   PARM                    PMsgId
     C                   PARM                    PMsgD
     C                   PARM                    PSProcPgm
     C                   PARM                    PSProcMod
     C                   PARM                    PSProcName
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCmdStr - Set up parameters for QCMDEX                      *
      *                                                               *
      *****************************************************************
     C     SRCmdStr      BEGSR
 
     C                   MOVEL     STRARR(1)     PCmdTxt1
     C                   MOVEL     STRARR(2)     PCmdTxt2
     C                   MOVEL     SSECU         PParm1
     C                   MOVEL     WDdte         PParm2
     C                   MOVEL     WEvtp         PParm3
     C                   MOVEL     STRARR(3)     PCmdTxt3                                     CSC023
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisp - Display screen                                      *
      *                                                               *
      *****************************************************************
     C     SRDisp        BEGSR
 
      ** Write message subfile, details and footer screens.
 
     C                   EVAL      *IN13 = *OFF
     C                   TIME                    STIME
     C                   WRITE     SE7608C1
     C                   WRITE     SE7608F1                                                 AR656294
     C                   WRITE     SE7608F0
     C**********         WRITE     SE7608F1                                                 AR656294
 
      ** Read details screen.
 
     C                   READ      SE7608F0                               01
 
      ** Clear message subfile.
 
     C                   CALL      'ZA0250'
 
      ** Set screen error indicators off.
 
     C                   MOVEA     '000'         *IN(10)
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValSEcu - Validate Security                                *
      *                                                               *
      *****************************************************************
     C     SRValSEcu     BEGSR
 
      ** Must reference an active record on SECTY
 
     C     SSECU         CHAIN     SECTYDF                            01
 
     C                   IF        ((*IN01 = *ON) OR  (*IN01 = *OFF)
     C                             AND  (RECI <> 'D'))  OR
     C                             CRTT = *BLANK
     C                   EVAL      *IN10 = *ON
     C                   EVAL      PMsgId = 'SEA0436'
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDDte - Validate To Date field                           *
      *                                                               *
      *****************************************************************
     C     SRValDDte     BEGSR
 
      ** Must be numeric.
 
     C                   TESTN                   SDDTE                01
 
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'SEA0437'
     C                   EXSR      SRSndM
     C                   GOTO      EValDdte
     C                   ENDIF
 
      ** Must be a valid date.
 
     C                   MOVE      *BLANKS       PDate
     C                   MOVE      SDDTE         PDate
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDate
     C                   PARM      *ZEROS        PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ErrorFlag
 
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'SEA0438'
     C                   EXSR      SRSndM
     C                   GOTO      EValDdte
     C                   ENDIF
 
      ** Must be greater than rundate
 
     C                   IF        PDaynoOut <= BJRDNB
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'SEA0439'
     C                   EXSR      SRSndM
     C                   GOTO      EValDdte
     C                   ENDIF
 
     C                   EVAL      WDdte = PDaynoOut
     C                   EVAL      EDdte = WDdte
 
     C     EValDdte      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValEVtp - Validate Country of Tax Treaty                   *
      *                                                               *
      *****************************************************************
     C     SRValEVtp     BEGSR
 
      ** If entered, event type must only be CP , DV or MA.
 
     C                   IF        ((SEVTP = *BLANKS) OR
     C                             (SEVTP <> 'CP') AND
     C                             (SEVTP <> 'DV') AND
     C                             (SEVTP <> 'MA'))
     C                   EVAL      *IN12 = *ON
     C                   EVAL      PMsgId = 'SEA0440'
     C                   EXSR      SRSndM
 
     C                   ELSE
 
     C                   IF        SEVTP = 'MA'
     C                   EVAL      WEvtp = 'MT'
     C                   EVAL      EEvtp = 'MG'
     C                   ELSE
     C                   EVAL      WEvtp = SEVTP
     C                   EVAL      EEvtp = SEVTP
     C                   IF        SEVTP = 'CP'
     C                   EVAL      EEvtp = 'CG'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access bank details.
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key fields for POSETW[
     C     WKey1         KLIST
     C                   KFLD                    SSECU
     C                   KFLD                    EEvtp
     C                   KFLD                    EDdte
 
     C                   EVAL      WScrn = 'P'
 
     C                   EVAL      PMsgf = 'GBSEUSRMSG'
 
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SWSID = PsJobName
 
      ** Message subfile control and program queue initialisation.
 
     C                   EVAL      *IN25 = *ON
     C                   EVAL      SPGM = '*'
 
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
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  STRARR
SBMJOB JOB(SEC7608) JOBD(BULKTJOBD) USER(*JOBD) RQSDTA('CALL PGM(SEC7608) PARM('              CPK014
'xxxxxxxxxx'' ''xxxxx'' ''xx'')') MSGQ(MOPERQ) RTGDTA(*JOBD) INLLIBL(*JOBD)
OUTQ(*JOBD)                                                                                   CSC023
