     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities maintenance screen 1 display')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS1DP - Securities Maintenance Screen 1 Display          *
      *                                                               *
      *  Function:  This module displays the Securities Maintenance   *
      *             Screen 1 details.                                 *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 10Dec06               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 232543             Date 18Mar05               *
      *                 CGL032             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL014             Date 20Oct03               *
      *                 CSE037             Date 29Apr02               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 192054             Date 28Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 12Jan01               *
      *                 186556             Date 07Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  232543 - Fix to CGL032 (Recompile)                           *
      *  CGL032 - Automatic Exchange of Information                   *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CSE037 - Countervalue rounding - recompile only for INVTP    *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  192054 - ISIN code must be available if Private banking is on*
      *  CSD006 - Market Data Feed                                    *
      *  186556 - Field protect number of decimal places for          *
      *           processing type 7 & 8.                              *
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
      ** Securities maintenance Screen 1 display file
     FSESECS1DF CF   E             WORKSTN
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
     FINVTPC    IF   E           K DISK    INFSR(*PSSR)                                       186556
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function  of Indicators                                      *
      *                                                               *
      *  01        End of File indicator                              *
      *  10-60     Field Error - highlight screen fields              *
      *  68        Position cursor on Action Code (if it is blank)    *
      *  69        Protect security key fields (action code and       *
      *            security reference)                                *
      *  70        Protect details fields                             *
      *  71        Enable CF05 - Refresh                              *
      *  72        Enable CF07 - Read Previous Record                 *
      *  73        Enable CF08 - Read Next Record                     *
      *  74        Enable CF10 - Delete                               *
      *  75        Enable CF15 - Select Record                        *
      *  76        Enable CF12 - Cancel                               *
      *  80        Midas-Plato Interface is present                   *
      *  81        CEU018(Securities Decimals on Nominals) is present *
      *  82        S01401(MT5xx Message Generation)                   *
      *  83        Private banking is present                         *                       192054
      *  84        Taxation on Savings Income is present              *                       CGL032
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
      ** Security retrieved from file - file file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
      *
      ** Security details screen 1 error indicators
     D SEESEC1       E DS                  EXTNAME(SEESEC1PD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Entry parameters definition
     D PEDtFld         S              1A
     D PEKyFld         S              1A
     D PEINKE          S              1A
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKJ          S              1A
     D PEINKL          S              1A
     D PEINKP          S              1A
     D BJMRDT          S              7A
     D BGN2ST          S              1A
     D CEU018          S              1A
     D S01401          S              1A
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
     D BGN4ST          S              1A                                                      192054
      *
      ** Work Fields
     D Cx              S              2P 0
     D Ex              S              2P 0
      *
      * Market Data Feed                                                                      CSD006
     D CSD006          S              1A                                                      CSD006
                                                                                              CSD006
      ** Taxation on Savings Income                                                           CGL032
     D CGL032          S              1A                                                      CGL032
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
     C                   MOVEA     SEESEC1       WEI
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
     C                   MOVEA     '011000000'   *IN(68)
      *
      ** Position cursor on Action Code if it is blank.
     C                   IF        SACTN = *BLANK
     C                   EVAL      *IN68 = *ON
     C                   ENDIF
      *
      ** Enable key fields.
     C                   IF        PEKyFld = 'Y'
     C                   EVAL      *IN69 = *OFF
     C                   ENDIF
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
      ** Enable CF07 (Read Previous Record).
      *
     C                   IF        PEINKG = 'Y'
     C                   EVAL      *IN72 = *ON
     C                   ENDIF
      *
      ** Enable CF08 (Read Next Record).
     C                   IF        PEINKH = 'Y'
     C                   EVAL      *IN73 = *ON
     C                   ENDIF
      *
      ** Enable CF10 (Delete).
     C                   IF        PEINKJ = 'Y'
     C                   EVAL      *IN74 = *ON
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
                                                                                              CGL032
      ** Display SSETX field.                                                                 CGL032
                                                                                              CGL032
     C                   IF        CGL032 = 'Y'                                               CGL032
     C                   EVAL      *IN84 = *ON                                                CGL032
     C                   ENDIF                                                                CGL032
      *
      ** Set status fields.
     C                   EVAL      SSTAT = *BLANKS
     C                   IF        SACTN = 'E'
     C                   IF        RECI = 'M'
     C                   EVAL      SSTAT = 'MATURED   '
     C                   ENDIF
     C                   IF        RECI = 'C'
     C                   EVAL      SSTAT = 'CANCELLED '
     C                   ENDIF
     C                   ENDIF
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
     C                   EVAL      PINKG = *INKG
     C                   EVAL      PINKH = *INKH
     C                   EVAL      PINKJ = *INKJ
     C                   EVAL      PINKL = *INKL
     C                   EVAL      PINKP = *INKP
 
      *  Set up key list for chaining into INVTPD                                             186556
      *                                                                                       186556
     C     PROTKey       KLIST                                                                186556
     C                   KFLD                    SSITP                                        186556
     C                   KFLD                    SNMCY                                        186556
      *                                                                                       186556
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
      ** Security retrieved from file - file file format
     C                   PARM                    CrSEFilFmt
      *
      ** Enable Detail Fields Indicator
      ** Enable Key Fields Indicator
     C                   PARM                    PEDtFld
     C                   PARM                    PEKyFld
      *
      ** Enable Function Keys
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
      *
      ** Security 1st screen error indicators
     C                   PARM                    SEESEC1
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
      *
      ** SDMMOD - Midas-Plato Interface
     C                   PARM                    BGN2ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Securities Decimals on Nominals
     C                   PARM                    CEU018
      *
      ** MT5xx Message Generation
     C                   PARM                    S01401
      *                                                                                       CSD006
      ** Market Data Feed on?                                                                 CSD006
     C                   PARM                    CSD006                                       CSD006
                                                                                              CGL032
      ** Taxation on Savings Income                                                           CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
      *                                                                                       192054
      ** SDMMOD - Private Banking Module                                                      192054
      *                                                                                       192054
     C                   PARM                    BGN4ST                                       192054
      *
      ** Midas-Plato Interface is present.
     C                   IF        BGN2ST = 'Y'
     C                   EVAL      *IN80 = *ON
     C                   ENDIF
      *
      ** SAR CEU018 is switched on.
     C                   IF        CEU018 = 'Y'
     C                   EVAL      *IN81 = *ON
     C                   ENDIF
      *                                                                                       192054
      ** Private Banking is present.                                                          192054
      *                                                                                       192054
     C                   IF        BGN4ST = 'Y'                                               192054
     C                   EVAL      *IN83 = *ON                                                192054
     C                   ENDIF                                                                192054
      *                                                                                       186556
      ** If processing type 7 or 8 field protect SNMDP field.                                 186556
      *                                                                                       186556
      *  Chain into INVTPD to find processing type and protect nominal                        186556
      *  decimal currency field if processing type 7 or 8.                                    186556
      *                                                                                       186556
     C     SSITP         IFNE      *BLANKS                                                    186556
     C     SNMCY         ANDNE     *BLANKS                                                    186556
      *                                                                                       186556
      *                                                                                       186556
     C     PROTKey       CHAIN     INVTPC                             99                      186556
      *                                                                                       186556
      * Database error                                                                        186556
     C                   IF        *IN99 = '1'                                                186556
     C                   MOVEL     '005'         DBASE                                        186556
     C                   MOVEL     'INVTPC'      DBFILE                                       186556
     C                   MOVEL     SSITP         PROTdbErr         6                          186556
     C                   MOVE      SNMCY         PROTdbErr                                    186556
     C                   MOVEL     PROTdbErr     DBKEY                                        186556
     C                   EXSR      *PSSR                                                      186556
     C                   ENDIF                                                                186556
      *                                                                                       186556
     C                   EVAL      *IN67 = *OFF                                               186556
      *                                                                                       186556
     C                   IF        PROT  = '7'                                                186556
     C                   EVAL      *IN67 = *ON                                                186556
     C                   ENDIF                                                                186556
      *                                                                                       186556
     C                   IF        PROT  = '8'                                                186556
     C                   EVAL      *IN67 = *ON                                                186556
     C                   ENDIF                                                                186556
      *                                                                                       186556
     C                   ENDIF                                                                186556
      *
      ** SAR S01401 is switched on.
     C                   IF        S01401 = 'Y'
     C                   EVAL      *IN82 = *ON
     C                   ENDIF
 
      ** Market Data Feed is present.                                                         CSD006
     C                   IF        CSD006 = 'Y'                                               CSD006
     C                   EVAL      *IN91 = *ON                                                CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
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
(c) Finastra International Limited 2001
**  WZ0
00000000000000000000000000000000000000000000000000
