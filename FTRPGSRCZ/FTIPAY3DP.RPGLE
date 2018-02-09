     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments level 2 scrn 2 display')    *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAY3DP - Incoming Payments Level 2 Screen 2 Display       *
      *                                                               *
      *  Function:  This module displays the Incoming Payments        *
      *             Level 2 screen 2 details.                         *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD035776           Date 10Sep15               *
      *                 MD027047           Date 19Aug14               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 259072             Date 02Mar09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
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
      *  MD046248 - Finastra Rebranding                               *
      *  MD035776 - User need to press twice on input screen          *
      *           - Remove unsupported keywords of HATS from dspf     *
      *             (Recompile)                                       *
      *  MD027047 - Avoid HATS issue with redisplaying previous screen*
      *             on the stack. End program with SETON LR with no   *
      *             RETURN.                                           *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  259072 - Recompiled due to changes in FTIPAY3DF display file *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
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
      ** Incoming Payments Level 2 Screen 2 display file
     FFTIPAY3DF CF   E             WORKSTN INFDS(ScrInfo)
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
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
      *       68         Account with Bank Institution is not         *
      *                  blank, display Outward Payment Indicator     *
      *       69         Analytical Accounting is on and Margin       *
      *                  Information details are to be displayed      *
      *                                                               *
      *       70         Protect details fields                       *
      *       71         Enable CF05 - Refresh                        *
      *       72         Enable CF07 - Read Previous Record           *
      *       73         Enable CF08 - Read Next Record               *
      *       74         Enable CF15 - Select Record                  *
      *       75         Enable CF18 - Next Payment                   *
      *                  (from linked enquiry)                        *
      *                                                               *
      *       81         BLI Funds Transfer Enhancement is on         *
      *       82         BLI VAT Processing is on                     *
      *       87         CFT014 is switched on.                       *         CFT014
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
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming
      ** transaction - screen format
     D NwIP4ScnFmt   E DS                  EXTNAME(FTIPY4PD)
     D NwIP4aScnFmt  E DS                  EXTNAME(FTIPY4APD)                   CFT014
      ***********                                                               CFT014
      ***Data*structure*for*default*Charge*Amounts*********************         CFT014
     D*PCharges        DS           108                                         CFT014
     D**DDTRCM***              1     12                                         CFT014
     D**DDTXCH***             13     24                                         CFT014
     D**DDCQCH***             25     36                                         CFT014
     D**DDADCH***             37     48                                         CFT014
     D**DDTLCH***             49     60                                         CFT014
     D**DDMSCH***             61     72                                         CFT014
     D**DDCHCM***             73     84                                         CFT014
     D**DDVATT***             85     96                                         CFT014
     D**DDVATD***             97    108                                         CFT014
      ***********                                                               CFT014
      ***Data*structure*for*default*Charge*Currencies******************         CFT014
     D*PChgCcy***      DS            48                                         CFT014
     D**DDCCY1***              1      3                                         CFT014
     D**DDCCY2***              4      6                                         CFT014
     D**DDCCY3***              7      9                                         CFT014
     D**DDCCY4***             10     12                                         CFT014
     D**DDCCY5***             13     15                                         CFT014
     D**DDCCY6***             16     18                                         CFT014
     D**DDCCY7***             19     21                                         CFT014
     D**DDCCY8***             22     24                                         CFT014
     D**DDRCY1***             25     27                                         CFT014
     D**DDRCY2***             28     30                                         CFT014
     D**DDRCY3***             31     33                                         CFT014
     D**DDRCY4***             34     36                                         CFT014
     D**DDRCY5***             37     39                                         CFT014
     D**DDRCY6***             40     42                                         CFT014
     D**DDRCY7***             43     45                                         CFT014
     D**DDRCY8***             46     48                                         CFT014
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     D FTEIPY3       E DS                  EXTNAME(FTEIPY3PD)
      *
      ** Display file information data structure
     D ScrInfo       E DS                  EXTNAME(Y2I#DSP)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Cursor position
     D  PRowCol        S              4B 0
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
     C                   MOVEA     FTEIPY3       WEI
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
      ** Enable CF15 (Browse screen).
      *
     C     PEINKP        IFEQ      'Y'
     C                   EVAL      *IN74 = *ON
     C                   ELSE
     C                   EVAL      *IN74 = *OFF
     C                   ENDIF
      *
      ** Enable CF18 (Next Payment).
      *
     C     PEINKS        IFEQ      'Y'
     C                   EVAL      *IN75 = *ON
     C                   ELSE
     C                   EVAL      *IN75 = *OFF
     C                   ENDIF
      *
      ** Enable F4 and F16.
      *
     C                   IF        PEINKD = 'Y' AND  PEINKQ = 'Y'
     C                   EVAL      *IN76 = *ON
     C                   ELSE
     C                   EVAL      *IN76 = *OFF
     C                   ENDIF
      *
      ** Set up Payment Status.
      *
     C                   MOVEL     PStatus       DDSTAT
      *
      ** If Account with Bank Institution is not blank, then display
      ** Outward Payment Indicator.
      *
     C     IPACBT        IFNE      *BLANK
     C                   EVAL      *IN68 = *ON
     C                   ELSE
     C                   EVAL      *IN68 = *OFF
     C                   ENDIF
      ***********                                                               CFT014
      ***Determine*whether*FX*Margin*fields*are*to*be*displayed.*******         CFT014
      ***********                                                               CFT014
     C***********        EXSR      SRMargin                                     CFT014
      *
      ** Write message subfile, details and footer screens.
      *
     C                   TIME                    DDTIME
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
      *
      ** If feature BIC database plus is installed, pass cursor position.
     C                   IF        CFT007 = 'Y'
     C                   Z-ADD     @#RWCL        PRowCol
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
     C                   MOVE      *INKL         PINKL
     C                   MOVE      *INKP         PINKP
     C                   MOVE      *INKQ         PINKQ
     C                   MOVE      *INKS         PINKS
      *
     C                   ENDSR
      *
      ********************************************************************
      ***/EJECT**                                                               CFT014
      ********************************************************************      CFT014
      ********************************************************************      CFT014
      ***SRMargin*-*Determine*whether*FX*Margin*fields*are*to*be**********      CFT014
      **************displayed*********************************************      CFT014
      ********************************************************************      CFT014
      ********************************************************************      CFT014
      ***********                                                               CFT014
     C*****SRMargin      BEGSR                                                  CFT014
      ***********                                                               CFT014
     C***********        MOVE      *OFF          *IN69                          CFT014
      ***********                                                               CFT014
      ***Analytical*Accounting*is*on.**********************************         CFT014
      ***********                                                               CFT014
     C*****BGN0ST        IFEQ      'Y'                                          CFT014
      ***********                                                               CFT014
     C***********        SELECT                                                 CFT014
      ***********                                                               CFT014
      ***Display*fields*for*Enquiry.***********************************         CFT014
      ***********                                                               CFT014
     C*****DDACTN        WHENEQ    'E'                                          CFT014
     C***********        MOVE      *ON           *IN69                          CFT014
      ***********                                                               CFT014
      ***For*Insert*and*Amend,*do*not*display*if*Pay*and*Settle*Currencies      CFT014
      ***are*the*same*and*Margin*Info*details*are*blanks.**************         CFT014
      ***********                                                               CFT014
     C*****IPPCCY        WHENEQ    IPSMCY                                       CFT014
     C*****DDFXMP        ANDEQ     *BLANKS                                      CFT014
     C*****DDMBSI        ANDEQ     *BLANKS                                      CFT014
     C*****DDMSIG        ANDEQ     *BLANKS                                      CFT014
     C***********        MOVE      *OFF          *IN69                          CFT014
      ***********                                                               CFT014
     C***********        OTHER                                                  CFT014
     C***********        MOVE      *ON           *IN69                          CFT014
      ***********                                                               CFT014
     C***********        ENDSL                                                  CFT014
      ***********                                                               CFT014
     C***********        ENDIF                                                  CFT014
      ***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
      ***********                                                               CFT014
      *****************************************************************         CFT014
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
      ** Action Code
     C                   PARM                    DDACTN            1
      *
      ** Payment Reference
     C                   PARM                    DDPREF           15
      *
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP4ScnFmt
     C                   PARM                    NwIP4aScnFmt                   CFT014
      ***********                                                               CFT014
      ***DS*for*default*Charge*Amounts*********************************         CFT014
     C***********        PARM                    PCharges                       CFT014
      ***********                                                               CFT014
      ***DS*for*default*Charge*Currencies******************************         CFT014
     C***********        PARM                    PChgCcy                        CFT014
      *
      ** Incoming Payment Status
     C                   PARM                    PStatus          10
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Enable Detail Fields
     C                   PARM                    PEDTFLD           1
      *
      ** Enable Function Keys
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
     C                   PARM                    PEINKD            1
     C                   PARM                    PEINKE            1
     C                   PARM                    PEINKG            1
     C                   PARM                    PEINKH            1
     C                   PARM                    PEINKP            1
     C                   PARM                    PEINKQ            1
     C                   PARM                    PEINKS            1
      *
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     C                   PARM                    FTEIPY3
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
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST            1
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494            1
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499            1
      *
      ** BIC database plus
     C                   PARM                    CFT007            1
      *                                                                         CFT014
      ** STP Phase 2 MT103 Messages Generation for FT.                          CFT014
     C                   PARM                    CFT014            1            CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
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
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
     C                   PARM                    PINKC             1
     C                   PARM                    PINKD             1
     C                   PARM                    PINKE             1
     C                   PARM                    PINKG             1
     C                   PARM                    PINKH             1
     C                   PARM                    PINKL             1
     C                   PARM                    PINKP             1
     C                   PARM                    PINKQ             1
     C                   PARM                    PINKS             1
      *
      ** Cursor position
     C                   PARM                    PRowCol
      *
      ** BLI Funds Transfer Enhancement feature is on.
      *
     C     S01494        IFEQ      'Y'
     C                   MOVE      *ON           *IN81
     C                   ELSE
     C                   MOVE      *OFF          *IN81
     C                   ENDIF
      *
      ** BLI VAT Processing feature is on.
      *
     C     S01499        IFEQ      'Y'
     C                   MOVE      *ON           *IN82
     C                   ELSE
     C                   MOVE      *OFF          *IN82
     C                   ENDIF
      *                                                                         CFT014
      ** STP Phase 2 MT103 Message Generation for FT feature is on.             CFT014
      *                                                                         CFT014
     C                   IF        CFT014 = 'Y'                                 CFT014
     C                   MOVE      *ON           *IN87                          CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      *OFF          *IN87                          CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
      *                                                                         CFT009
     C     CFT009        IFEQ      'Y'                                          CFT009
     C                   MOVE      *ON           *IN88                          CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *OFF          *IN88                          CFT009
     C                   ENDIF                                                  CFT009
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
      *
     C                   EVAL      ModuleID     = 'FT'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
      *
     C                   EVAL      #MsgFile     = 'FTUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
      *
      ** Message subfile control and program queue initialisation
      *
     C                   MOVE      *ON           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
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
(c) Finastra International Limited 2001
** WZ0
000000000000000000000000000000000000000000000000000000000000
