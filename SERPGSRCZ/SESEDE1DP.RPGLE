     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Security Diary Events screen 1 display')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDE1DP - Security Diary Events screen 1 display           *
      *                                                               *
      *  Function: This module will process the security diary        *
      *            events screen 1 details.                           *
      *                                                               *
      *  Component of: SESEDESIN                                      *
      *                SESEDERPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP140  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    10-60      Field Error - highlight screen fields           *
      *                                                               *
      *    61         Enable fields for dividend declared (DV)        *
      *    62         Enable fields for interest rate change (IR)     *
      *    63         Enable fields for partly paid shares (PP)       *
      *    64         Enable fields for partly paid non-shares        *
      *    65         Enable fields for redemption calls (RC)         *
      *    66         Enable fields for mortgage payment (MP)         *
      *    67         Enable fields for exchange rate (XR)            *
      *    68         Enable fields for conversions (CV)              *
      *    69         Enable field for bonus issues (BI)              *
      *    77         Enable field for maturity date (AL)             *                       CSE065
      *    85         Enable field for right issues (RI)              *
      *    86         Enable field for capital reorganisation (CR)    *
      *    87         Enable field for other changes (OC)             *
      *    88         Enable field for redemption puts (RP)           *
      *                                                               *
      *    71         Enable CF05 - Refresh                           *
      *    72         Enable CF07 - Read previous record              *
      *               Enable CF08 - Read next record                  *
      *    73         Enable CF10 - Confirm deletion                  *
      *    74         Enable CF12 - Cancel                            *
      *    75         Enable CF15 - Select record                     *
      *                                                               *                       CAS006
      *    76         CAS006 is installed.                            *                       CAS006
      *                                                               *
      *    80         Enable fields when S01509 is installed.         *
      *    81         Enable fields when S01510 is installed.         *
      *    82         Enable analysis cashflow field.                 *
      *    89         Enable help in narrative field for 'PP'         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRMainP - Main processing                                    *
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
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Security diary events screen 1
     FSESEDE1DDFCF   E             WORKSTN INFSR(*PSSR)
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

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
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     D NwDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
     D                                     PREFIX(S:2)
      *
      ** SE Diary events retrieved from file - file format
     D CrDEFilFmt    E DS                  EXTNAME(SEDEVD)
                                                                                              CAS006
      ** Externally described DS for security details                                         CAS006
     D PSectyd       E DS                  EXTNAME(SECTYD)                                    CAS006
     D                                     PREFIX(D1)                                         CAS006
      *
      ** SE Diary events screen error indicators
     D SEESEDE       E DS                  EXTNAME(SEESEDEPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Work Fields
     D Cx              S              2P 0
     D Ex              S              2P 0
      *
      ** Function keys to activate
     D PEINKE          S              1A
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKJ          S              1A
     D PEINKL          S              1A
     D PEINKP          S              1A
      *
      ** Function keys activated
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
      *
      ** Work parameters
     D RMFL            S              1A
     D PPROT           S              1A
     D PEDtFld         S              1A
     D S01509          S              1A
     D S01510          S              1A
     D CAS006          S              1A                                                      CAS006
     D CSE065          S              1A                                                      CSE065
     D BJMRDT          S              7A
     D CGL031          S              1A                                                      CGL031
                                                                                              CAS006
      ** Parameters for ZEDIT                                                                 CAS006
     D ZField          S             16A                                                      CAS006
     D ZADec           S              1P 0                                                    CAS006
      *
      ** Output screen fields
     D SCUCR           S             12A
     D SSEXR           S             14A
     D SMATY           S              8A                                                      CSE065
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
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Main processing.
      *
     C                   EXSR      SRMainP
      *
      ** Return.
      *
     C                   IF        PINKC = *ON
     C                   EVAL      *INLR = *ON
     C                   ENDIF

     C                   RETURN
      *
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
     C                   MOVEA     SEESEDE       WEI
      *
      ** Set screen error indicators according to status of 'OK' flags.
      *
     C                   Z-ADD     1             Cx
     C                   Z-ADD     10            Ex

     C                   DOU       Cx > 60

     C                   IF        WEI(Cx) = 'N' OR WEI(Cx) = 'W'
     C                   EVAL      *IN(Ex) = *ON
     C                   ENDIF

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
     C                   MOVEA     '000000000'   *IN(61)
     C                   EVAL      *IN77 = *OFF                                               CSE065
     C                   MOVEA     '00000'       *IN(85)
      *
      ** Position cursor on Action Code if it is blank.
      *
     C                   IF        SACTN = *BLANK
     C                   EVAL      *IN60 = *ON
     C                   ELSE
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
      ** Enable detail fields.
      *
     C                   IF        PEDtFld = 'Y'
     C                   EVAL      *IN70 = *OFF
     C                   ELSE
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
      *
      ** Enable CF05 (Refresh).
      *
     C                   IF        PEINKE = 'Y'
     C                   EVAL      *IN71 = *ON
     C                   ELSE
     C                   EVAL      *IN71 = *OFF
     C                   ENDIF
      *
      ** Enable CF07,CF08 (Read Previous,Next Record)
      *
     C                   IF        PEINKG = 'Y' OR PEINKH = 'Y'
     C                   EVAL      *IN72 = *ON
     C                   ELSE
     C                   EVAL      *IN72 = *OFF
     C                   ENDIF
      *
      ** Enable CF10 (Confirm deletion)
      *
     C                   IF        PEINKJ = 'Y'
     C                   EVAL      *IN73 = *ON
     C                   ELSE
     C                   EVAL      *IN73 = *OFF
     C                   ENDIF
      *
      ** Enable CF12 (Cancel).
      *
     C                   IF        PEINKL = 'Y'
     C                   EVAL      *IN74 = *ON
     C                   ELSE
     C                   EVAL      *IN74 = *OFF
     C                   ENDIF
      *
      ** Enable CF15 (Browse screen).
      *
     C                   IF        PEINKP = 'Y'
     C                   EVAL      *IN75 = *ON
     C                   ELSE
     C                   EVAL      *IN75 = *OFF
     C                   ENDIF
      *
      ** Set status field.
      *
     C                   EVAL      SSTAT = *BLANKS
     C                   IF        SACTN = 'E'
     C                   IF        RECI = 'M'
     C                   EVAL      SSTAT = 'MATURED   '
     C                   ENDIF
     C                   ENDIF
                                                                                              CGL031
      ** Taxation of Savings Income field.                                                    CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y' AND                                           CGL031
     C                             SSDET = 'DV'                                               CGL031
     C                   EVAL      *IN84 = *ON                                                CGL031
     C                   ELSE                                                                 CGL031
     C                   EVAL      *IN84 = *OFF                                               CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Enable respective fields for each event type.
      *
     C                   SELECT

     C                   WHEN      SSDET = 'DV'
     C                   EVAL        *IN61 = *ON

     C                   WHEN      SSDET = 'IR'
     C                   EVAL        *IN62 = *ON

     C                   WHEN      SSDET = 'PP'
     C                   EVAL        *IN89 = *ON
     C                   IF        PPROT = '4'
     C                   EVAL        *IN63 = *ON
     C                   ELSE
     C                   EVAL        *IN64 = *ON
     C                   ENDIF

     C                   WHEN      SSDET = 'RC'
     C                   EVAL        *IN65 = *ON

     C                   WHEN      SSDET = 'MP'
     C                   EVAL        *IN66 = *ON

     C                   WHEN      SSDET = 'XR'
     C                   EVAL        *IN67 = *ON

     C                   WHEN      SSDET = 'CV'
     C                   EVAL        *IN68 = *ON

     C                   WHEN      SSDET = 'BI'
     C                   EVAL        *IN69 = *ON

     C                   WHEN      SSDET = 'RI'
     C                   EVAL        *IN85 = *ON

     C                   WHEN      SSDET = 'CR'
     C                   EVAL        *IN86 = *ON

     C                   WHEN      SSDET = 'OC'
     C                   EVAL        *IN87 = *ON

     C                   WHEN      SSDET = 'RP'
     C                   EVAL        *IN88 = *ON
                                                                                              CSE065
     C                   WHEN      CSE065 = 'Y' AND                                           CSE065
     C                             SSDET = 'AL'                                               CSE065
     C                   EVAL        *IN77 = *ON                                              CSE065

     C                   ENDSL
                                                                                              CAS006
     C                   EVAL      SNTCR = *BLANKS                                            CAS006
     C                   IF        CAS006 = 'Y' AND                                           CAS006
     C                             *IN62 = *ON                                                CAS006
     C                   EVAL      *IN76 = *ON                                                CAS006
                                                                                              CAS006
     C                   IF        D1CPNN <> *ZEROS                                           CAS006
     C                   MOVE      *BLANKS       ZField                                       CAS006
     C                   MOVE      D1CPNN        ZField                                       CAS006
     C                   Z-ADD     7             ZADec                                        CAS006
     C                   CALLB     'ZEDIT'                                                    CAS006
     C                   PARM                    ZField                                       CAS006
     C                   PARM                    ZADec                                        CAS006
     C                   MOVE      ZField        SNTCR                                        CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
      *
      ** Write message subfile, details and footer screens.
      *
     C                   TIME                    STIME
     C                   WRITE     SESEDE1DF0
     C                   WRITE     SESEDE1DF1
     C                   WRITE     SESEDE1DC0
      *
      ** If not Write Only, read details screen.
      *
     C                   IF        WriteOnly <> 'Y'
     C                   READ      SESEDE1DF0                             01
     C                   ENDIF
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
      *
      ** Set screen error indicators off.
      *
     C                   MOVEA     WZ0           *IN(10)
      *
      ** Set return keys.
      *
     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKE = *INKE
     C                   EVAL      PINKG = *INKG
     C                   EVAL      PINKH = *INKH
     C                   EVAL      PINKJ = *INKJ
     C                   EVAL      PINKL = *INKL
     C                   EVAL      PINKP = *INKP

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
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
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
                                                                                              CAS006
      ** Externally described DS for Security details                                         CAS006
     C                   PARM                    PSectyd                                      CAS006
      *
      ** Cumulative coupon rate
     C                   PARM                    SCUCR
      *
      ** Current exchange rate
     C                   PARM                    SSEXR
                                                                                              CSE065
      ** Maturity Date                                                                        CSE065
     C                   PARM                    SMATY                                        CSE065
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Enable detail fields indicator
     C                   PARM                    PEDtFld
      *
      ** Enable function keys
      ** KE = Command key 05 = Refresh
      ** KG = Command key 07 = Read Previous
      ** KH = Command key 08 = Read Next
      ** KJ = Command key 10 = Delete
      ** KL = Command key 12 = Cancel
      ** KP = Command key 15 = Browse
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
      *
      ** SE Diary events screen error indicators
     C                   PARM                    SEESEDE
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
      ** Write screen with no read indicator
     C                   PARM                    WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = Command key 03 = Exit
      ** KE = Command key 05 = Refresh
      ** KG = Command key 07 = Read Previous
      ** KH = Command key 08 = Read Next
      ** KJ = Command key 10 = Delete
      ** KL = Command key 12 = Cancel
      ** KP = Command key 15 = Browse
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
      *
      ** If feature 'Value currency to be currency of issuer payments'
      ** is installed, enable relevant fields.
      *
     C                   IF        S01509 = 'Y'
     C                   EVAL      *IN80 = *ON
     C                   ELSE
     C                   EVAL      *IN80 = *OFF
     C                   ENDIF
      *
      ** If feature 'Dividend payments' is installed, enable relevant
      ** fields.
      *
     C                   IF        S01510 = 'Y'
     C                   EVAL      *IN81 = *ON
     C                   ELSE
     C                   EVAL      *IN81 = *OFF
     C                   ENDIF
      *
      ** Strategic risk management.
      *
     C                   IF        RMFL = 'Y'
     C                   EVAL      *IN82 = *ON
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF

     C                   EVAL      SUSER = PsUser
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
      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
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
