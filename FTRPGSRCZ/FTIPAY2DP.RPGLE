     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments level 2 scrn 1 display')    *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAY2DP - Incoming Payments Level 2 Screen 1 Display       *
      *                                                               *
      *  Function:  This module displays the Incoming Payments        *
      *             Level 2 screen 1 details.                         *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD035776           Date 10Sep15               *
      *  Prev Amend No. MD027047           Date 19Aug14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15119           Date 24Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD035776 - User need to press twice on input screen          *
      *           - Remove unsupported keywords of HATS from dspf     *
      *             (Recompile)                                       *
      *  MD027047 - Avoid HATS issue with redisplaying previous screen*
      *             on the stack. End program with SETON LR with no   *
      *             RETURN.                                           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
/*    *  BUG15119 - Reverse image on the 6th line of the Bank to Bank *
/*    *             Information instead of the 5th line of Ordering   *
/*    *             Customer (Recompile)                              *
      *  CFT032 - Account Line in field 50X in MT103 (recompile)      *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT. Recompile only.         *
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
      ** Incoming Payments Level 2 Screen 1 display file
     FFTIPAY2DF CF   E             WORKSTN INFDS(ScrInfo)
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
      *       70         Protect details fields                       *
      *       71         Enable CF05 - Refresh                        *
      *       72         Enable CF07 - Read Previous Record           *
      *       73         Enable CF08 - Read Next Record               *
      *       74         Enable CF15 - Select Record                  *
      *       75         Enable CF18 - Next Payment                   *
      *                  (from linked enquiry)                        *
      *                                                               *
      *       80         Multibranching                               *
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
      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming
      ** transaction - screen format
     D NwIP2ScnFmt   E DS                  EXTNAME(FTIPY2PD)
      *
      ** Incoming Payments Lvl 2 Scrn 1/2 details from incoming
      ** transaction - screen format
     D NwIP3ScnFmt   E DS                  EXTNAME(FTIPY3PD)
      *
      ** Incoming Payments Lvl 2 Scrn 1 error indicators
     D FTEIPY2       E DS                  EXTNAME(FTEIPY2PD)
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
     C                   MOVEA     FTEIPY2       WEI
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
      ** Action Code
     C                   PARM                    DDACTN            1
      *
      ** Payment Reference
     C                   PARM                    DDPREF           15
      *
      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP2ScnFmt
      *
      ** Incoming Payments Lvl 2 Scrn 1/2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP3ScnFmt
      *
      ** Incoming Payment Status
     C                   PARM                    PStatus          10
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
      ** Incoming Payments Lvl 2 Scrn 1 error indicators
     C                   PARM                    FTEIPY2
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
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BIC database plus
     C                   PARM                    CFT007            1
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
      ** Single Branch not used (Multiple branch).
     C     BJSBRC        IFEQ      *BLANK
     C                   MOVE      *ON           *IN80
     C                   ENDIF
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
(c) Misys International Banking Systems Ltd. 2001
** WZ0
000000000000000000000000000000000000000000000000000000000000
