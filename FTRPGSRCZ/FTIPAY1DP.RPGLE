     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments level 1 scrn display')      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAY1DP - Incoming Payments Level 1 Screen Display        *
      *                                                               *
      *  Function: This module displays the Incoming Payments         *
      *            Level 1 screen details.                            *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD027047           Date 19Aug14               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257074             Date 24Oct08               *
      *                 256586             Date 18Sep08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 241002             Date 18Jul06               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027047 - Avoid HATS issue with redisplaying previous screen*
      *             on the stack. End program with SETON LR with no   *
      *             RETURN.                                           *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  257074 - Re-position field 'Ref Rate' to bottom right of     *
      *           screen. (Recompile)                                 *
      *  256586 - Missing Ref Rate in webfaced FT maintenance.        *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  241002 - Cannot amend booking branch. Applied 227458.        *
      *  227458 - Recompile due to change in FTIPAY1DF.  Applied part *
      *           of 219713.                                          *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Incoming Payments Level 1 Screen display file
     FFTIPAY1DF CF   E             WORKSTN INFDS(ScrInfo)
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
     F/COPY WNCPYSRC,FTIPA1XF01
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       01         End of File indicator                        *
      *                                                               *
      *     10-60        Field Error - highlight screen fields        *
      *                                                               *
      *       68         Position cursor on Action Code (if it is     *
      *                  blank)                                       *
      *                                                               *
      *       70         Protect details fields                       *
      *       71         Enable CF05 - Refresh                        *
      *       72         Enable CF07 - Read Previous Record           *
      *       73         Enable CF08 - Read Next Record               *
      *       74         Enable CF10 - Delete                         *
      *       75         Enable CF15 - Select Record                  *
      *       76         Enable CF18 - Next Payment                   *
      *                  (from linked enquiry)                        *
      *       77         Enable CF21 - Additional info window         *
      *       78         *RPR function: enable Booking Branch and     *
      *                  non-display SWIFT Reference and Sequence No. *
      *                                                               *
      *       80         Multibranching                               *
      *       81         Originating Branch used                      *
      *       83         Profit Centres used                          *
      *       84         Settlement Currency Conversion feature is    *
      *                  on: display Notified Delivery Currency and   *
      *                  Amount.                                      *
      *       87         CFT014 is switched on.                       *         CFT014
      *       85         CDL049 is ON, display ref rate field         *                       256586
      *       89         validation error in field ref rate           *                       256586
      *                                                               *
      *       96         Subfile control                              *
      *       97         Subfile end                                  *
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
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn 1/2 details from incoming transaction     CFT014
      ** - screen format                                                        CFT014
     D NwIP1aScnFmt  E DS                  EXTNAME(FTIPY1APD)                   CFT014
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     D FTEIPY1       E DS                  EXTNAME(FTEIPY1PD)
      *
      ** Display file information data structure
     D ScrInfo       E DS                  EXTNAME(Y2I#DSP)
                                                                                              256586
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  256586
      ** External DS for Midas Switchable Features details                                    256586
                                                                                              256586
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     256586
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                   256586
     D/COPY WNCPYSRC,FTIPA1XD01
      *
      ** DS for Additional Information details
     D PAddInfm        DS           196
     D  DDUSRP1                1     10
     D  DDUSER1               11     35
     D  DDUSRP2               36     45
     D  DDUSER2               46     70
     D  DDAUP1                71     80
     D  DDAUT1                81    105
     D  DDAUP2               106    115
     D  DDAUT2               116    140
     D  DDNMIR               141    168
     D  DDNMOR               169    196
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Cursor position
     D  PRowCol        S              4B 0
     D/COPY WNCPYSRC,FTIPA1XD02
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
      *
     C                   EXSR      SRMainP
      *
      ** Return.
      *
     C*****PINKC         IFEQ      *ON                                                      MD027047
     C                   EVAL      *INLR = *ON
     C**********         ENDIF                                                              MD027047
      *
     C**********         RETURN                                                             MD027047
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMainP - Main processing                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRMainP       BEGSR
      *
      ** Move 'OK' flags into array (for checking).
      *
     C                   MOVEA     FTEIPY1       WEI
      *
      ** Set screen error indicators according to status of 'OK' flags.
      *
     C                   Z-ADD     1             Cx                2 0
     C                   Z-ADD     10            Ex                2 0
      *
     C     Cx            DOUGT     60
      *
     C     WEI(Cx)       IFEQ      'N'
     C     WEI(Cx)       OREQ      'W'
     C                   MOVEL     *ON           *IN(Ex)
     C                   ENDIF
      *
     C                   ADD       1             Cx
     C                   ADD       1             Ex
     C                   ENDDO
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
      *
      ** Position cursor on Action Code if it is blank.
      *
     C     DDACTN        IFEQ      *BLANK
     C                   EVAL      *IN68 = *ON
     C                   ELSE
     C                   EVAL      *IN68 = *OFF
     C                   ENDIF
      *
      ** Enable detail fields.
      *
     C     PEDTFLD       IFEQ      'Y'
     C                   EVAL      *IN70 = *OFF
     C                   ELSE
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
      *
      ** Enable CF05 (Refresh).
      *
     C     PEINKE        IFEQ      'Y'
     C                   EVAL      *IN71 = *ON
     C                   ELSE
     C                   EVAL      *IN71 = *OFF
     C                   ENDIF
      *
      ** Enable CF07 (Read Previous Record).
      *
     C     PEINKG        IFEQ      'Y'
     C                   EVAL      *IN72 = *ON
     C                   ELSE
     C                   EVAL      *IN72 = *OFF
     C                   ENDIF
      *
      ** Enable CF08 (Read Next Record).
      *
     C     PEINKH        IFEQ      'Y'
     C                   EVAL      *IN73 = *ON
     C                   ELSE
     C                   EVAL      *IN73 = *OFF
     C                   ENDIF
      *
      ** Enable CF10 (Delete).
      *
     C     PEINKJ        IFEQ      'Y'
     C                   EVAL      *IN74 = *ON
     C                   ELSE
     C                   EVAL      *IN74 = *OFF
     C                   ENDIF
      *
      ** Enable CF15 (Browse screen).
      *
     C     PEINKP        IFEQ      'Y'
     C                   EVAL      *IN75 = *ON
     C                   ELSE
     C                   EVAL      *IN75 = *OFF
     C                   ENDIF
      *
      ** Enable CF18 (Next Payment).
      *
     C     PEINKS        IFEQ      'Y'
     C                   EVAL      *IN76 = *ON
     C                   ELSE
     C                   EVAL      *IN76 = *OFF
     C                   ENDIF
      *
      ** Enable CF21 (Additional info).
      *
     C     PEINKV        IFEQ      'Y'
     C                   EVAL      *IN77 = *ON
     C                   ELSE
     C                   EVAL      *IN77 = *OFF
     C                   ENDIF
      *
      ** Enable F4 and F16.
      *
     C                   IF        PEINKD = 'Y' AND  PEINKQ = 'Y'
     C                   EVAL      *IN79 = *ON
     C                   ELSE
     C                   EVAL      *IN79 = *OFF
     C                   ENDIF
      *
      ** If process mode is repair, enable Booking Branch and do not
      ** display SWIFT Reference and Sequence No.
      *
     C     PMode         IFEQ      '*RPR  '
     C                   EVAL      *IN78 = *ON
     C                   ELSE
     C                   EVAL      *IN78 = *OFF
     C                   ENDIF
     C/COPY WNCPYSRC,FTIPA1XC05
      *
      ** Set up Payment Status and Payment Type.
      *
     C                   MOVEL     PStatus       DDSTAT
     C                   MOVEL     PPYTP         DDPYTP
      *
      ** Write message subfile, details and footer screens.
      *
     C                   TIME                    DDTIME
      * Set screen error indicator for field Ref. Rate                                        256586
     C     'DDRRAT    '  LOOKUP    FldNameArr                             89                  256586
     C                   If        *IN89 = *OFF                                               256586
     C     'DDRRAT    '  LOOKUP    WFldNamArr                             89                  256586
     C                   EndIf                                                                256586
     C/COPY WNCPYSRC,FTIPA1XC01
      *
     C                   WRITE     FTIPAYS0
     C                   WRITE     FTIPAYD1
     C                   WRITE     FTIPAYF1
      *
      ** If not Write Only, read details screen.
      *
     C     PWriteOnly    IFNE      'Y'
     C                   READ      FTIPAYD1                               01
     C                   ENDIF
     C/COPY WNCPYSRC,FTIPA1XC02
      *
      ** If feature BIC database plus is installed, pass cursor position.
      *
     C                   IF        CFT007 = 'Y'
     C                   Z-ADD     @#RWCL        PRowCol
     C                   ENDIF
      *
      ** If F21 taken, display Additional Info window.
      *
     C     *INKV         IFEQ      *ON
     C                   EXFMT     FTIPAYD2
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
     C                   MOVE      *INKC         PINKC
     C                   MOVE      *INKD         PINKD
     C                   MOVE      *INKE         PINKE
     C                   MOVE      *INKG         PINKG
     C                   MOVE      *INKH         PINKH
     C                   MOVE      *INKJ         PINKJ
     C                   MOVE      *INKL         PINKL
     C                   MOVE      *INKP         PINKP
     C                   MOVE      *INKQ         PINKQ
     C                   MOVE      *INKS         PINKS
     C                   MOVE      *INKV         PINKV
      *
     C                   ENDSR
      *
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
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn 1/2 details from incoming trans.          CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP1aScnFmt                   CFT014
      *
      ** DS for Additional Information details
     C                   PARM                    PAddInfm
      *
      ** SWIFT Reference
     C                   PARM                    DDSWTN           28
      *
      ** Sequence No.
     C                   PARM                    DDSEQNO           2
      *
      ** Incoming Payment Status
     C                   PARM                    PStatus          10
      *
      ** Payment Type
     C                   PARM                    PPYTP             2
      *
      ** Display Additional Information Screen Indicator
     C                   PARM                    PAddInfo          1
      *
      ** Enable Detail Fields Indicator
     C                   PARM                    PEDTFLD           1
      *
      ** Enable Function Keys
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
      ** KV = Command Key 21 = Additional Information Window
     C                   PARM                    PEINKD            1
     C                   PARM                    PEINKE            1
     C                   PARM                    PEINKG            1
     C                   PARM                    PEINKH            1
     C                   PARM                    PEINKJ            1
     C                   PARM                    PEINKP            1
     C                   PARM                    PEINKQ            1
     C                   PARM                    PEINKS            1
     C                   PARM                    PEINKV            1
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
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
     C                   PARM                    PWriteOnly        1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT            7
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC            3
      *
      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU            1
      *
      ** SDGELR - Originating Branch Used
     C                   PARM                    BKOBRU            1
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006            1
      *
      ** BIC database plus
     C                   PARM                    CFT007            1
      *
      ** Electronic Banking Interface IATs and TPPs
     C                   PARM                    CGL009            1
      *                                                                         CFT014
      ** STP Phase 2 MT103 Messages Generation for FT.                          CFT014
     C                   PARM                    CFT014            1            CFT014
     C/COPY WNCPYSRC,FTIPA1XC09
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
     C/COPY WNCPYSRC,FTIPA1XC06
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
      ** KV = Command Key 21 = Additional Information Window
     C                   PARM                    PINKC             1
     C                   PARM                    PINKD             1
     C                   PARM                    PINKE             1
     C                   PARM                    PINKG             1
     C                   PARM                    PINKH             1
     C                   PARM                    PINKJ             1
     C                   PARM                    PINKL             1
     C                   PARM                    PINKP             1
     C                   PARM                    PINKQ             1
     C                   PARM                    PINKS             1
     C                   PARM                    PINKV             1
      *
      ** Cursor position
     C                   PARM                    PRowCol
     C/COPY WNCPYSRC,FTIPA1XC03
      *
      ** Single Branch not used (Multiple branch).
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   MOVE      *ON           *IN80
     C                   ENDIF
      *
      ** Originating Branch used.
      *
     C     BKOBRU        IFEQ      'Y'
     C     BJSBRC        ANDEQ     *BLANK
     C                   MOVE      *ON           *IN81
     C                   ENDIF
      *
      ** Profit Centres used.
      *
     C     BKPRCU        IFEQ      'Y'
     C                   MOVE      *ON           *IN83
     C                   ENDIF
      *
      ** EMU Settlement Currency Conversion feature is on.
      *
     C     CEU006        IFEQ      'Y'
     C                   MOVE      *ON           *IN84
     C                   ENDIF
      *
      ** Electronic Banking Interface IATs and TPPs feature is on.
      *
     C                   IF        CGL009 = 'Y'
     C                   MOVE      *ON           *IN86
     C                   ENDIF
      *                                                                         CFT014
      ** STP Phase 2 MT103 Message Generation for FT feature is on.             CFT014
      *                                                                         CFT014
     C                   IF        CFT014 = 'Y'                                 CFT014
     C                   MOVE      *ON           *IN87                          CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      *OFF          *IN87                          CFT014
     C                   ENDIF                                                  CFT014
     C/COPY WNCPYSRC,FTIPA1XC10
      *                                                                         CFT009
      ** Fees & Charges feature is on.                                          CFT009
      *                                                                         CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
     C                   MOVE      *ON           *IN88                          CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *OFF          *IN88                          CFT009
     C                   ENDIF                                                  CFT009
      ** Access SAR details file to determine if CDL049 is on                                 256586
      ** For display of Reference Rate field                                                  256586
                                                                                              256586
     C                   CALL      'AOSARDR0'                                                 256586
     C                   PARM      *Blanks       @RTCD                                        256586
     C                   PARM      '*VERIFY'     @OPTN                                        256586
     C                   PARM      'CDL049'      @SARD                                        256586
     C     SCSARD        PARM      SCSARD        DSFDY                                        256586
                                                                                              256586
     C                   IF        (@RTCD <> *BLANKS) And                                     256586
     C                             (@RTCD <> '*NRF   ')                                       256586
     C                   MOVEL     'SCSARDPD'    DBFILE                                       256586
     C                   Z-ADD     905           DBASE                                        256586
     C                   MOVEL     'CDL049'      DBKEY                                        256586
     C                   EXSR      *PSSR                                                      256586
     C                   ENDIF                                                                256586
                                                                                              256586
     C                   IF        @RTCD = *BLANKS                                            256586
     C                   EVAL      *IN85 = *ON                                                256586
     C                   ENDIF                                                                256586
     C/COPY WNCPYSRC,FTIPA1XC07
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
      *
     C                   EVAL      ModuleID     = 'FT'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
     C/COPY WNCPYSRC,FTIPA1XC08
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
      *
     C                   EVAL      #MsgFile     = 'FTUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
     C/COPY WNCPYSRC,FTIPA1XC11
      *
      ** Message subfile control and program queue initialisation.
      *
     C                   MOVE      *ON           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
     C/COPY WNCPYSRC,FTIPA1XC04
      *
     C                   ENDSR
      *
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
** WZ0
000000000000000000000000000000000000000000000000000000000000
