     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Alloc per divdnd pymnt summary rpt-Prompt')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE7602P - Allocations per dividend payment summary           *
      *            report - Prompt                                    *
      *                                                               *
      *  Function:  This module provides the input screen for         *
      *             the user  selection input of Allocations          *
      *             per Dividend Summary Report                       *
      *                                                               *
      *  Component of: SE7602 Allocations per Dividend Summary        *
      *                Report                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. AR689705           Date 03Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023  *CREATE    Date 03Aug00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *  AR656294 - HATS issue                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSE023 - Treaty Witholding Tax                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Allocations per dividend payment summary report display file
     FSE7602DF  CF   E             WORKSTN
 
      ** Securities details
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function  of Indicators                                      *
      *                                                               *
      *  01        End of File indicator                              *
      *  10-60     Field Error - highlight screen fields              *
      *  25        Subfile control                                    *
      *  25        Subfile end                                        *
      *  90-99     Used by standard subroutine                        *
      *  KC        F3 pressed = Exit                                  *
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
 
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Output DS
     D POutFlds        DS           100
     D  PSECU                  1     10A
     D  PPYDN                 11     15  0
     D  PEVTP                 16     17A
 
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
     D PReDsp          S              1A
 
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
 
     D PSequence       S              5A
     D PLevel          S              1A
     D PEntity         S              3A
     D PAction         S              1A
     D PCmd            S              1A
 
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
 
     C                   CALLB     'ZAMSGCLRPG'
     C                   PARM                    PSProcPgm
     C                   PARM                    PSProcMod
     C                   PARM                    PSProcName
 
      ** Do while SCREEN : Read details.
 
     C                   DOW       WScrn = 'P'
     C                   EXSR      SRDisp
     C                   IF        *INKC = *ON
     C                   EVAL      PCmd = 'E'
     C                   EVAL      WScrn = 'E'
     C                   ELSE
     C                   EXSR      SRVal
     C                   ENDIF
     C                   ENDDO
 
      ** Do file update.
 
     C                   IF        WScrn = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
 
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
 
     C                   CLEAR                   POutFlds
     C                   CLEAR                   SSECU
     C                   CLEAR                   SPYDT
     C                   CLEAR                   SEVTP
 
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
     C                   EXSR      SRValPYdt
     C                   EXSR      SRValEVtp
 
      ** If no errors, update output parameter field.
 
     C                   IF        ((*IN10 = *OFF) AND  (*IN11 = *OFF) AND
     C                             (*IN12 = *OFF))
     C                   EVAL      WScrn = 'U'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update output parameter fields                    *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
     C                   EVAL      PSECU = SSECU
     C                   EVAL      PPYDN = PDaynoOut
     C                   EVAL      PEVTP = SEVTP
 
     C                   EVAL      WScrn = 'E'
 
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
      *  SRDisp - Display screen                                      *
      *                                                               *
      *****************************************************************
     C     SRDisp        BEGSR
 
      ** Write message subfile, details and footer screens.
 
     C                   TIME                    STIME
     C                   WRITE     SE7602C1
     C**********         WRITE     SE7602F0                                                 AR656294
     C                   WRITE     SE7602F1
     C                   WRITE     SE7602F0                                                 AR656294
 
      ** Read details screen.
 
     C                   READ      SE7602F0                               01
 
      ** Clear message subfile.
 
     C                   CALL      'ZA0250'
 
      ** Set screen error indicators off.
 
     C                   MOVEA     '000'         *IN(10)
     C                   EVAL      PReDsp = 'N'
 
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
     C                             AND  (RECI <> 'D'))
     C                   EVAL      *IN10 = *ON
     C                   MOVEL     'SEA0430'     PMsgId
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValPYdt - Validate To Date field                           *
      *                                                               *
      *****************************************************************
     C     SRValPYdt     BEGSR
 
      ** Must be numeric.
 
     C                   TESTN                   SPYDT                01
 
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN11 = *ON
     C                   MOVEL     'SEA0431'     PMsgId
     C                   EXSR      SRSndM
     C                   GOTO      EValPYdt
     C                   ENDIF
 
      ** Must be a valid date.
 
     C                   MOVE      *BLANKS       PDate
     C                   MOVE      SPYDT         PDate
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDate
     C                   PARM      *ZEROS        PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ErrorFlag
 
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      *IN11 = *ON
     C                   MOVEL     'SEA0432'     PMsgId
     C                   EXSR      SRSndM
     C                   GOTO      EValPYdt
     C                   ENDIF
 
     C     EValPYdt      ENDSR
 
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
     C                   MOVEL     'SEA0433'     PMsgId
     C                   EXSR      SRSndM
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
 
     C     *ENTRY        PLIST
     C                   PARM                    PSequence
     C                   PARM                    PLevel
     C                   PARM                    PEntity
     C                   PARM                    POutFlds
     C                   PARM                    PAction
     C                   PARM                    PCmd
 
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
     C                   Z-ADD     1             DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WScrn = 'P'
 
     C                   EVAL      PMsgf = 'GBSEUSRMSG'
 
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SWSID = PsJobName
 
      ** Message subfile control and program queue initialisation.
 
     C                   MOVE      *ON           *IN25
     C                   MOVEL     '*'           SPGM
 
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
