     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities maintenance screen 3 display')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS3DP - Securities Maintenance Screen 3 Display          *
      *                                                               *
      *  Function:  This module displays the Securities Maintenance   *
      *             screen 3 details.                                 *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CSE075             Date 06Mar06               *
      *                 CGL032             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE065             Date 08Nov04               *
      *                 CGL014             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 12Jan01               *
      *                 CPB002             Date 14Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - CSE075 Change Control. Display Coupon Delay period  *
      *           for all interest-bearing securities.                *
      *  CGL032 - Automatic Exchange of Information                   *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus.          *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CGL014 - Collaterals Processing                              *
      *  CSD006 - Market Data Feed (recompile)                        *
      *  CPB002  - 'Private Banking' Module                           *
      *            Instrument/Investment Type field amendable when    *
      *           + system setup flag is off                          *
      *           + system setup flag is on but no position exists    *
      *  CAP137 - Conversion of Security inputs into modular          *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Securities Maintenance Screen 3 display file
     FSESECS3DF CF   E             WORKSTN
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *                                                                         CPB002
     FCPOSS     IF   E           K DISK    INFSR(*PSSR)                         CPB002
     F                                     IGNORE(DPOSNDF)                      CPB002
      *                                                                                       CSE065
      ** Midas SE Securities File                                                             CSE065
     FSECTY     IF   E           K DISK    INFSR(*PSSR)                                       CSE065
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function  of Indicators                                      *
      *                                                               *
      *  01        End of File indicator                              *
      *  10-60     Field Error - highlight screen fields              *
      *  70        Protect details fields                             *
      *  71        Enable CF05 - Refresh                              *
      *  72        Enable CF07 - Read Previous Record                 *
      *  73        Enable CF08 - Read Next Record                     *
      *  74        Enable CF06 - Return to initial screen             *
      *  75        Enable CF15 - Select Record                        *
      *  76        Enable CF12 - Cancel                               *
      *  80        Private Banking is present                         *
      *  81        Protect PB Instrument Type                         *         CPB002
      *  96        Subfile control                                    *
      *  97        Subfile end                                        *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
      *
      /COPY ZACPYSRC,MSGHNDDCL
      *
      ** The following /COPY line declares the arrays for processing that
      ** take place in the *CTL modules.
      *
      /COPY ZACPYSRC,APICTLARR
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
      *
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
      ** Arrays for screen error indicators
     D WZ0             S              1    DIM(60) CTDATA PERRCD(60)
     D WEI             S              1    DIM(60)
      *
      ** Security screen 1 details from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
     D                                     PREFIX(S:2)
      *
      ** Security screen 3 details from incoming transaction
      ** - screen format
     D NwSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
     D                                     PREFIX(S:2)
      *
      ** Security details screen 3 error indicators
     D SEESEC3       E DS                  EXTNAME(SEESEC3PD)
      *                                                                                       CSE065
      ** Externally described DS for SAR details                                              CSE065
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSE065
      *                                                                                       CSE065
      ** DS for Access Objects - second data structure                                        CSE065
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSE065
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Entry parameters definition
     D RUNDAT          DS            13                                         CPB002
     D    RUNA                 1      7                                         CPB002
     D    RUND                 8     10P 0                                      CPB002
     D    SSF                 11     11                                         CPB002
     D    DATF                12     12                                         CPB002
     D    MBIN                13     13                                         CPB002
     D PEDtFld         S              1A
     D PProT           S              1A                                                      CSE065
     D PEINKE          S              1A
     D PEINKF          S              1A
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKL          S              1A
     D PEINKP          S              1A
     D BJMRDT          S              7A
     D BJRDNB          S              5P 0                                                    CSE065
     D BGN4ST          S              1A
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKF           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
      *                                                                                       CSE065
      ** Switchable features                                                                  CSE065
     D CSE065          S              1A                                                      CSE065
     D CSE075          S              1A                                                      CSE075
      *                                                                                       CSE065
      ** Parameters for AOSARDR0                                                              CSE065
     D PRtCd           S              7A                                                      CSE065
     D POptn           S              7A                                                      CSE065
     D PSard           S              6A                                                      CSE065
      *
      ** Work Fields
     D Cx              S              2P 0
     D Ex              S              2P 0
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
                                                                                              CGL032
      ** Taxation on Savings Income                                                           CGL032
     D CGL032          S              1A                                                      CGL032
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Main processing.
     C                   EXSR      SRMainP
      *
      ** Return.
     C                   IF        PINKC = *ON
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMainP - Main processing                                    *
      *                                                               *
      *****************************************************************
     C     SRMainP       BEGSR
      *
      ** Move 'OK' flags into array (for checking).
      *
     C                   MOVEA     SEESEC3       WEI
      *
      ** Set screen error indicators according to status of 'OK' flags.
      *
     C                   Z-ADD     1             Cx
     C                   Z-ADD     10            Ex
      *
     C                   DOU       Cx > 60
      *
     C                   IF        WEI(Cx) = 'N' OR WEI(Cx) = 'W'
     C                   EVAL      *IN(Ex) = *ON
     C                   ENDIF
      *
     C                   EVAL      Cx = Cx + 1
     C                   EVAL      Ex = Ex + 1
     C                   ENDDO
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
      *
      ** Reset work indicators.
     C                   MOVEA     '1000000'     *IN(70)
      *
      ** Enable detail fields.
     C                   IF        PEDtFld = 'Y'
     C                   EVAL      *IN70 = *OFF
     C                   ENDIF
      *
      ** Enable CF05 (Refresh).
     C                   IF        PEINKE = 'Y'
     C                   EVAL      *IN71 = *ON
     C                   ENDIF
      *
      ** Enable CF06 (Init Scrn).
     C                   IF        PEINKF = 'Y'
     C                   EVAL      *IN74 = *ON
     C                   ENDIF
      *
      ** Enable CF07 (Read Previous Record).
     C                   IF        PEINKG = 'Y'
     C                   EVAL      *IN72 = *ON
     C                   ENDIF
      *
      ** Enable CF08 (Read Next Record).
     C                   IF        PEINKH = 'Y'
     C                   EVAL      *IN73 = *ON
     C                   ENDIF
      *
      ** Enable CF12 (Cancel).
     C                   IF        PEINKL = 'Y'
     C                   EVAL      *IN76 = *ON
     C                   ENDIF
      *
      ** Enable CF15 (Browse screen).
     C                   IF        PEINKP = 'Y'
     C                   EVAL      *IN75 = *ON
     C                   ENDIF
      *                                                                                       CSE065
      ** Enable Average Life Date field if CSE065 is on and Processing                        CSE065
      ** Type is not '2', '4', nor '7'                                                        CSE065
     C                   IF        CSE065 = 'N' OR                                            CSE065
     C                             PProT  = '2' OR                                            CSE065
     C                             PProT  = '4' OR                                            CSE065
     C                             PProT  = '7'                                               CSE065
     C                   EVAL      *IN82 = *OFF                                               CSE065
     C                   ELSE                                                                 CSE065
     C                   EVAL      *IN82 = *ON                                                CSE065
      *                                                                                       CSE065
      ** Average Life Date is only amendable on entry date                                    CSE065
     C                   IF        SACTN = 'A'                                                CSE065
      *                                                                                       CSE065
      ** Retrieve security details                                                            CSE065
     C     SSESN         CHAIN     SECTY                                                      CSE065
     C                   IF        %FOUND(SECTY)                                              CSE065
     C                   IF        ORED <> BJRDNB                                             CSE065
     C                   EVAL      *IN77 = *ON                                                CSE065
     C                   ELSE                                                                 CSE065
     C                   EVAL      *IN77 = *OFF                                               CSE065
     C                   ENDIF                                                                CSE065
     C                   ENDIF                                                                CSE065
     C                   ENDIF                                                                CSE065
     C                   ENDIF                                                                CSE065
      *                                                                                       CSE075
      ** Enable US Enhanced Treasury fields.                                                  CSE075
      *                                                                                       CSE075
     C                   IF        CSE075 = 'Y' AND                                           CSE075
     C                             PProT  = '8'                                               CSE075
     C                   EVAL      *IN83 = *ON                                                CSE075
     C                   ELSE                                                                 CSE075
     C                   EVAL      *IN83 = *OFF                                               CSE075
     C                   ENDIF                                                                CSE075
                                                                                              CSE075
      ** Use Indicator 85 for Coupon Delay Period                                             CSE075
                                                                                              CSE075
     C                   IF        CSE075 = 'Y'                                               CSE075
     C                   IF        PProT <> '2' AND                                           CSE075
     C                             PProT <> '4' AND                                           CSE075
     C                             PProT <> '7'                                               CSE075
     C                   EVAL      *IN85 = *ON                                                CSE075
     C                   ELSE                                                                 CSE075
     C                   EVAL      *IN85 = *OFF                                               CSE075
     C                   ENDIF                                                                CSE075
     C                   ENDIF                                                                CSE075
                                                                                              CSE075
                                                                                              CGL032
      ** Display new narrative 'Issue Fiscal Price'.                                          CGL032
                                                                                              CGL032
     C                   IF        CGL032 = 'Y'                                               CGL032
     C                   EVAL      *IN84 = *ON                                                CGL032
     C                   ENDIF                                                                CGL032
      *
      ** Write message subfile, details and footer screens.
     C                   TIME                    STIME
     C                   WRITE     SESECSC1
     C                   WRITE     SESECSD1
     C                   WRITE     SESECSF1
      *
      ** If not Write Only, read details screen.
     C                   IF        WriteOnly <> 'Y'
     C                   READ      SESECSD1                               01
     C                   ENDIF
      *
      ** Clear message subfile.
     C                   CALL      'ZA0250'
      *
      ** Set screen error indicators off.
     C                   MOVEA     WZ0           *IN(10)
      *
      ** Set return keys.
     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKE = *INKE
     C                   EVAL      PINKF = *INKF
     C                   EVAL      PINKG = *INKG
     C                   EVAL      PINKH = *INKH
     C                   EVAL      PINKL = *INKL
     C                   EVAL      PINKP = *INKP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP2
      *
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
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Security 1st screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Security 3rd screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Enable Detail Fields Indicator
     C                   PARM                    PEDtFld
      *                                                                                       CSE065
      ** Processing Type indicator                                                            CSE065
     C                   PARM                    PProT                                        CSE065
      *
      ** Enable Function Keys
      ** KE = Command Key 05 = Refresh
      ** KF = Command Key 06 = Initial Screen
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
     C                   PARM                    PEINKE
     C                   PARM                    PEINKF
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
      *
      ** Security 3rd screen error indicators
     C                   PARM                    SEESEC3
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM                    WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System run date
     C                   PARM                    BJMRDT
      *                                                                                       CSE065
      ** SDBANK - System run day number                                                       CSE065
     C                   PARM                    BJRDNB                                       CSE065
      *
      ** SDMMOD - Private Banking
     C                   PARM                    BGN4ST
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
                                                                                              CGL014
     C                   PARM                    CGL014                                       CGL014
                                                                                              CGL032
      ** SWITCHABLE FEATURES                                                                  CGL032
      ** ===================                                                                  CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KE = Command Key 05 = Refresh
      ** KF = Command Key 06 = Initial Screen
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKF
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
 
      *
      ** Private Banking is present.
      *
     C                   EVAL      *IN81 = *OFF                                 CPB002
     C                   IF        BGN4ST = 'Y'
     C                   EVAL      *IN80 = *ON
      *                                                                         CPB002
     C     *DTAARA       DEFINE                  RUNDAT                         CPB002
     C                   IN        RUNDAT                                       CPB002
      *                                                                         CPB002
     C                   EVAL      *IN81 = *OFF                                 CPB002
     C     SSF           IFEQ      'Y'                                          CPB002
     C     SACTN         ANDEQ     'A'                                          CPB002
     C                   EVAL      *IN81 = *ON                                  CPB002
     C                   ENDIF                                                  CPB002
      *                                                                         CPB002
     C     *IN81         IFEQ      *ON                                          CPB002
     C     SSESN         CHAIN     CPOSS                              99        CPB002
     C     *IN99         IFEQ      *ON                                          CPB002
     C                   EVAL      *IN81 = *OFF                                 CPB002
     C                   ENDIF                                                  CPB002
     C                   ENDIF                                                  CPB002
      *                                                                         CPB002
     C                   ENDIF
 
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SWSID = PsJobName
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
      *
     C                   EVAL      ModuleID     = 'SE'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
      *
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
      *
      ** Message subfile control and program queue initialisation.
      *
     C                   MOVE      *ON           *IN97
     C                   MOVEL     '*'           SPGMQ
                                                                                              CGL014
      ** If CGL014 is on, enable weighting code and instrument type                           CGL014
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'                                               CGL014
     C                   EVAL      *IN82 = *ON                                                CGL014
     C                   ENDIF                                                                CGL014
      *                                                                                       CSE065
      ** Check if CSE065 is installed                                                         CSE065
     C                   EVAL      CSE065 = 'N'                                               CSE065
     C                   CALLB     'AOSARDR0'                                                 CSE065
     C                   PARM      *Blanks       PRtcd                                        CSE065
     C                   PARM      '*VERIFY'     POptn                                        CSE065
     C                   PARM      'CSE065'      PSard                                        CSE065
     C     SCSARD        PARM      SCSARD        DSSDY                                        CSE065
                                                                                              CSE065
     C                   IF        PRTCD = *Blanks                                            CSE065
     C                   EVAL      CSE065 = 'Y'                                               CSE065
     C                   ELSE                                                                 CSE065
     C                   IF        PRTCD <> '*NRF   '                                         CSE065
     C     *LOCK         IN        LDA                                                        CSE065
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSE065
     C                   EVAL      DBKEY  = 'CSE065'                                          CSE065
     C                   EVAL      DBASE  = 1                                                 CSE065
     C                   OUT       LDA                                                        CSE065
     C                   EXSR      *PSSR                                                      CSE065
     C                   ENDIF                                                                CSE065
     C                   ENDIF                                                                CSE065
      *                                                                                       CSE075
      ** Check if CSE075 is installed.                                                        CSE075
      *                                                                                       CSE075
     C                   EVAL      CSE075 = 'N'                                               CSE075
     C                   CALLB     'AOSARDR0'                                                 CSE075
     C                   PARM      *Blanks       PRtcd                                        CSE075
     C                   PARM      '*VERIFY'     POptn                                        CSE075
     C                   PARM      'CSE075'      PSard                                        CSE075
     C     SCSARD        PARM      SCSARD        DSSDY                                        CSE075
                                                                                              CSE075
     C                   IF        PRTCD = *Blanks                                            CSE075
     C                   EVAL      CSE075 = 'Y'                                               CSE075
     C                   ELSE                                                                 CSE075
     C                   IF        PRTCD <> '*NRF   '                                         CSE075
     C     *LOCK         IN        LDA                                                        CSE075
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSE075
     C                   EVAL      DBKEY  = 'CSE075'                                          CSE075
     C                   EVAL      DBASE  = 2                                                 CSE075
     C                   OUT       LDA                                                        CSE075
     C                   EXSR      *PSSR                                                      CSE075
     C                   ENDIF                                                                CSE075
     C                   ENDIF                                                                CSE075
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  WZ0
00000000000000000000000000000000000000000000000000
