     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments lvl 2 init scrn display')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAYSDP - Incoming Payments Level 2 Initial Screen         *
      *              Display                                          *
      *                                                               *
      *  Function: This module displays the initial fields (Action    *
      *            Code and Payment Reference) in Level 2 input.      *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CFT032             Date 11Sep06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CFT009             Date 13Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
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
      ** Incoming Payments Level 2 Initial Screen display file
     FFTIPAYSDF CF   E             WORKSTN
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
      *     10-11        Field Error - highlight screen fields        *
      *                                                               *
      *     61-63        Condition display of messages (available     *
      *                  functions) on screen footer                  *
      *       68         Position cursor on Action Code               *
      *                  (if it is blank)                             *
      *                                                               *
      *       70         Protect screen fields                        *
      *       71         Enable CF07 - Read Previous Record           *
      *       72         Enable CF08 - Read Next Record               *
      *       73         Enable CF15 - Select Record                  *
      *       74         Enable CF18 - Next Payment                   *
      *                  (from linked enquiry)                        *
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
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
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
     C     PINKC         IFEQ      *ON
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
     C                   RETURN
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
     C                   MOVEL     *BLANKS       FTEIPYS           2
      *
     C                   EVAL      FTEIPYS = OKACTN + OKPREF
      *
     C                   MOVEA     FTEIPYS       WEI
      *
      ** Set screen error indicators according to status of 'OK' flags.
      *
     C                   Z-ADD     1             Cx                2 0
     C                   Z-ADD     10            Ex                2 0
      *
     C     Cx            DOUGT     2
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
      ** Enable screen fields.
      *
     C     PEDTKEY       IFEQ      'Y'
     C                   EVAL      *IN70 = *OFF
     C                   ELSE
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
      *
      ** Enable CF07 (Read Previous Record).
      *
     C     PEINKG        IFEQ      'Y'
     C                   EVAL      *IN71 = *ON
     C                   ELSE
     C                   EVAL      *IN71 = *OFF
     C                   ENDIF
      *
      ** Enable CF08 (Read Next Record).
      *
     C     PEINKH        IFEQ      'Y'
     C                   EVAL      *IN72 = *ON
     C                   ELSE
     C                   EVAL      *IN72 = *OFF
     C                   ENDIF
      *
      ** Enable CF15 (Browse screen).
      *
     C     PEINKP        IFEQ      'Y'
     C                   EVAL      *IN73 = *ON
     C                   ELSE
     C                   EVAL      *IN73 = *OFF
     C                   ENDIF
      *
      ** Enable CF18 (Next Payment).
      *
     C     PEINKS        IFEQ      'Y'
     C                   EVAL      *IN74 = *ON
     C                   ELSE
     C                   EVAL      *IN74 = *OFF
     C                   ENDIF
      *
      ** Write message subfile, details and footer screens.
      *
     C                   MOVEA     '000'         *IN(61)
      *
     C     PEDTKEY       IFEQ      'Y'
     C                   MOVEL     *ON           *IN61
     C                   ELSE
      *
     C     PEINKS        IFEQ      'Y'
     C                   MOVEL     *ON           *IN63
     C                   ELSE
      *
     C                   MOVEL     *ON           *IN62
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   TIME                    DDTIME
      *
     C                   WRITE     FTIPAYS0
     C                   WRITE     FTIPAYD1
     C                   WRITE     FTIPAYF1
      *
      ** Read Initial screen.
      *
     C                   READ      FTIPAYD1                               01
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
     C                   MOVE      *INKG         PINKG
     C                   MOVE      *INKH         PINKH
     C                   MOVE      *INKL         PINKL
     C                   MOVE      *INKP         PINKP
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
      ** Enable Screen Fields
     C                   PARM                    PEDTKEY           1
      *
      ** Enable Function Keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KP = Command Key 15 = Browse
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
     C                   PARM                    PEINKG            1
     C                   PARM                    PEINKH            1
     C                   PARM                    PEINKP            1
     C                   PARM                    PEINKS            1
      *
      ** OK Action Code
     C                   PARM                    OKACTN            1
      *
      ** OK Payment Reference
     C                   PARM                    OKPREF            1
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
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT            7
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
     C                   PARM                    PINKC             1
     C                   PARM                    PINKG             1
     C                   PARM                    PINKH             1
     C                   PARM                    PINKL             1
     C                   PARM                    PINKP             1
     C                   PARM                    PINKS             1
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
     C                   EVAL      MsgFArray(2) = 'MEMSG'
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
