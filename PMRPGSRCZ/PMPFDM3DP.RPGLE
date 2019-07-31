     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio Definition Details Display')        *
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDM3DP - Portfolio Definition Details Display            *
      *                                                               *
      *  Function: This module displays the main details screen of    *
      *            the Portfolio Definition screen input function.    *
      *            Key fields (Action Code, Customer Number and       *
      *            Portfolio Reference) are protected on the screen.  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR689705           Date 03Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 198173             Date 24Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 13Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *  AR656294 - HATS issue                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  198173 - Review CPB002 - For a PB customer, portfolio ccy,   *
      *           narrative and date opened/closed must be protected  *
      *  CPB002 - New Private Banking Customer Processing.            *
      *           Just recompile                                      *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Main Details screen
     FPMPFDM3DDFCF   E             WORKSTN
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-48 Field Error - highlight screen fields               *
      *                                                               *
      *       68  Position cursor on Action Code                      *
      *       70  Protect detail fields                               *
      *       71  Enable CF01                                         *
      *       72  Enable CF07                                         *
      *       73  Enable CF08                                         *
      *       74  Enable CF15                                         *
      *       75  Enable CF24                                         *
      *                                                               *
      *       76  Allow input of Date Closed                          *
      *       80  Allow input of Investment Policy Indicators         *
      *       81  Allow input of Custody Fee Group Code               *
      *       82  Allow input of FF Margin A/C Sequence               *
      *       83  Allow input of Profit Centre                        *
      *       84  Protect Pledge Start and Finish Dates               *
      *                                                               *
      *       96  Message subfile display control                     *
      *       97  Message subfile end                                 *
      *                                                               *
      *       99  End of file indicator                               *
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
      ** Externally described DS for Customer Details                                         198173
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  198173
      *                                                                                       198173
      ** DS for Access Programs - very long data structure                                    198173
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     198173
      *                                                                                       198173
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
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
     D WZ0             S              1    DIM(60) CTDATA PERRCD(60)
     D WEI             S              1    DIM(60)
      *
      ** Portfolio Definition Details from incoming transaction
      ** - in screen format
     D NwDfScnFmt    E DS                  EXTNAME(PMPFDMPD)
      *
      ** Investment Policy Indicators from incoming transaction
      ** - (DDIPIN) Instrument Investment Policy Indicator
      ** - (DDCYIN) Currency Investment Policy Indicator
      ** - (DDYPIN) Country of Risk Investment Policy Indicator
      ** - (DDNPIN) Industry Investment Policy Indicator
     D PCurInvest      DS
     D  DDIPIN
     D  DDCYIN
     D  DDYPIN
     D  DDNPIN
      *
      ** Error indicators
     D PMEPMD        E DS                  EXTNAME(PMEPFDMPD)
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
      ** Main processing
      *
     C                   EXSR      SRMAINP
      *
      ** Return
      *
     C     PINKC         IFEQ      '1'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMAINP - Main processing                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRMAINP       BEGSR
      *
      ** Move 'OK' flags into array (for checking).
      *
     C                   MOVEA     PMEPMD        WEI
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
     C                   MOVEL     '1'           *IN(Ex)
     C                   ENDIF
      *
     C                   ADD       1             Cx
     C                   ADD       1             Ex
     C                   ENDDO
      *
      ** Set up the transaction reference to be used by the message handler.
      *
     C                   MOVEL     DDCSNM        WTRAN            10
     C                   MOVE      DDPREF        WTRAN
     C                   MOVEL     WTRAN         TranRef
     C                   EVAL      ActionCode = DDACTN
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
      *
      ** Position cursor on action code if it is blank.
      *
     C     DDACTN        IFEQ      *BLANK
     C                   EVAL      *IN68 = *ON
     C                   ELSE
     C                   EVAL      *IN68 = *OFF
     C                   ENDIF
      *
      ** Enable Portfolio Definition Date Closed field.
      *
     C     PEDT_DPCL     IFEQ      'Y'
     C                   EVAL      *IN76 = *ON
     C                   ELSE
     C                   EVAL      *IN76 = *OFF
     C                   ENDIF
      *
      ** Enable detail fields (all fields except key fields).
      *
     C     PEDTFD        IFEQ      'Y'
     C                   EVAL      *IN70 = *OFF
     C                   ELSE
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
      *
      ** Enable Investment Policy Indicators.
      *
     C     PSIN80        IFEQ      'Y'
     C                   EVAL      *IN80 = *ON
     C                   ELSE
     C                   EVAL      *IN80 = *OFF
     C                   ENDIF
      *
      ** Enable CF01 (Portfolio Charges screen).
      *
     C     PEINKA        IFEQ      'Y'
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
      ** Enable CF24 (Notepad screen).
      *
     C     PEINKY        IFEQ      'Y'
     C                   EVAL      *IN75 = *ON
     C                   ELSE
     C                   EVAL      *IN75 = *OFF
     C                   ENDIF
      *
      ** Write message subfile, details and footer screen.
      *
     C                   WRITE     PMPFDMS0
     C                   TIME                    DDTIME
     C                   WRITE     PMPFDMF1                                                 AR656294
      *
      ** Switch indicators to protect fields ccy, narrative and dates                         198173
      *                                                                                       198173
     C                   MOVE      '0'           *IN50                                        198173
     C                   MOVE      '0'           *IN51                                        198173
     C*                                                                                       198173
     C     DDACTN        IFEQ      'A'                                                        198173
     C                   MOVE      '1'           *IN50                                        198173
      ** Access customer details.                                                             198173
      *                                                                                       198173
     C                   CALLB     'AOCUSTR1'                                                 198173
     C                   PARM      *BLANKS       PRTCD             7                          198173
     C                   PARM      '*KEY'        POPTN             7                          198173
     C                   PARM      DDCSNM        PCNUM            10                          198173
     C                   PARM                    PKEY              7                          198173
     C     SDCUST        PARM      SDCUST        DSLDY                                        198173
      *                                                                                       198173
      ** Error if Customer not found.                                                         198173
      *                                                                                       198173
     C     PRTCD         IFEQ      *BLANKS                                                    198173
     C     BBPRBA        ANDEQ     'Y'                                                        198173
     C                   MOVE      '1'           *IN51                                        198173
     C                   ENDIF                                                                198173
     C                   ENDIF                                                                198173
      *                                                                                       198173
      ** Condition write of record format on PM Customer flag.
      *
     C     PMCUST        IFNE      'Y'
     C                   WRITE     PMPFDMD2
     C                   ELSE
     C                   WRITE     PMPFDMD1
     C                   ENDIF
      *
     C**********         WRITE     PMPFDMF1                                                 AR656294
      *
      ** If not write only, read details screen.
      *
     C     WriteOnly     IFNE      'Y'
      *
      ** Condition read of record format on PM Customer flag.
      *
     C     PMCUST        IFNE      'Y'
     C                   READ      PMPFDMD2                               99
     C                   ELSE
     C                   READ      PMPFDMD1                               99
     C                   ENDIF
      *
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
     C                   MOVE      *INKA         PINKA
     C                   MOVE      *INKC         PINKC
     C                   MOVE      *INKG         PINKG
     C                   MOVE      *INKH         PINKH
     C                   MOVE      *INKL         PINKL
     C                   MOVE      *INKP         PINKP
     C                   MOVE      *INKY         PINKY
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
     C                   PARM                    RetCodeIn
      *
      ** Portfolio Definition Details from incoming transaction
      ** - in screen format
     C                   PARM                    NwDfScnFmt
      *
      ** Investment Policy Indicators from incoming transaction
     C                   PARM                    PCurInvest
      *
      ** Portfolio Date Opened in screen format
      ** - for insert, rundate
      ** - for other action codes, value retrieved from file
     C                   PARM                    DDDPOP
      *
      ** CLOSED/CLOSURE REQUEST narrative - for display
     C                   PARM                    DDDELT
      *
      ** Enable Portfolio Date Closed field
     C                   PARM                    PEDT_DPCL         1
      *
      ** Display Investment Policy Indicators
     C                   PARM                    PSIN80            1
      *
      ** Enable detail fields
     C                   PARM                    PEDTFD            1
      *
      ** Enable function keys
      ** KA = Command key 01 = PORTFOLIO CHARGES
      ** KG = Command Key 07 = READ PREVIOUS
      ** KH = Command Key 08 = READ NEXT
      ** KP = Command Key 15 = BROWSE
      ** KY = Command key 24 = NOTEPAD
     C                   PARM                    PEINKA            1
     C                   PARM                    PEINKG            1
     C                   PARM                    PEINKH            1
     C                   PARM                    PEINKP            1
     C                   PARM                    PEINKY            1
      *
      ** Portfolio Definition Fields OK indicators
     C                   PARM                    PMEPMD
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
     C                   PARM                    WriteOnly         1
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST            1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST            1
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP            1
      *
      ** SDMMOD - Future & Options
     C                   PARM                    BGFUOP            1
      *
      ** SDMMOD - Portfolio Lending
     C                   PARM                    BGLMCR            1
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464            1
      *
      ** Profit Centre feature
     C                   PARM                    CAC003            1
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys
     C                   PARM                    PINKA             1
     C                   PARM                    PINKC             1
     C                   PARM                    PINKG             1
     C                   PARM                    PINKH             1
     C                   PARM                    PINKL             1
     C                   PARM                    PINKP             1
     C                   PARM                    PINKY             1
      *
      ** Allow input of Custody Fee Group Code.
      *
     C     S01464        IFEQ      'Y'
     C     FBFGCP        ANDEQ     'Y'
     C                   MOVE      '1'           *IN81
     C                   ENDIF
      *
      ** Allow input of FF Margin A/C Sequence.
      *
     C     BGFUOP        IFEQ      'Y'
     C                   MOVE      '1'           *IN82
     C                   ENDIF
      *
      ** Allow input of Profit Centre.
      *
     C     BGN0ST        IFEQ      'Y'
     C     CAC003        ANDEQ     'Y'
     C                   MOVE      '1'           *IN83
     C                   ENDIF
      *
      ** Protect Pledge Start and Finish Dates.
      *
     C     BGLMCR        IFEQ      'Y'
     C                   MOVE      '1'           *IN84
     C                   ENDIF
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
      *
     C                   EVAL      ModuleID     = 'PM'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
      *
     C                   EVAL      #MsgFile     = 'PMUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
      *
      ** Message subfile control and program queue initialisation
      *
     C                   MOVE      '1'           *IN97
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
