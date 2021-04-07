     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio defns convert file to scrn fmt')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDM2CT - Portfolio Definition Details Conversion:        *
      *               File to Screen Format                           *
      *                                                               *
      *  Function: This module converts the fields of a Portfolio     *
      *            Definition Details from their format as on file    *
      *            to a screen format.                                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. HUT113             Date 01Apr20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 13Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT113 - Full Private Banking Functionality in FM            *
      *           Applies fixes MD-54548 and MD-54322                 *
      *           Addition of hooks HUT113_004 to HUT113_008          *
      *    MD054548 - Error is found in Portfolio Definition Maint.   *
      *               (Inconsistency on screen).                      *
      *             - Display the new PB screen for cust either PM    *
      *               or PB when HUT113 feature is ON.                *
      *    MD054322 - PM - SE - Incorrect holdings for                *
      *               custody fee calculation report.                 *
      *               Allow portfolio definition for PB customer.     *
      *               Addition of hooks HUT113_004 to HUT113_008      *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CPB002 - New Private Banking Customer Processing.            *
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
      **    False      logical = *off (for indicator processing)
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
      ** Portfolio Definition Details retrieved from file
      ** - in file format
     D PPORTFILFMT   E DS                  EXTNAME(PMVPFDMPD)
      *
      ** Portfolio Definition Details retrieved from file
      ** - converted to screen format
     D PMPFDM        E DS                  EXTNAME(PMPFDMPD)
      *
     D/COPY WNCPYSRC,HUT113_004                                                            HUT113
      *
      ** Investment Policy Indicators retrieved from file
      ** - converted to screen format
      ** - (DDIPIN) Instrument Investment Policy Indicator
      ** - (DDCYIN) Currency Investment Policy Indicator
      ** - (DDYPIN) Country of Risk Investment Policy Indicator
      ** - (DDNPIN) Industry Investment Policy Indicator
      *
     D PCURINVEST      DS             4
     D   DDIPIN                1      1
     D   DDCYIN                2      2
     D   DDYPIN                3      3
     D   DDNPIN                4      4
      *
     D/COPY WNCPYSRC,HUT113_005                                                            HUT113
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
     C                   EXSR      SRINIT
      *
     C                   EXSR      SRSetOutput
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Routine to initialise fields                        *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Initialise output parameters.
      *
     C                   CLEAR                   PMPFDM
     C                   CLEAR                   PCURINVEST
     C                   CLEAR                   DDDPOP
     C                   CLEAR                   DDDELT
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetOutput - Routine to move the contents of the fields     *
      *                from file to screen fields                     *
      *                                                               *
      *****************************************************************
      *
     C     SRSetOutput   BEGSR
      *
      ** Action Code
      *
     C                   MOVEL     PDDACTN       DDACTN
      *
      ** CLOSED narrative
      *
     C     P1PNRECI      IFEQ      '*'
     C                   MOVE      'CLOSED'      DDDELT
     C                   ELSE
      *
      ** CLOSURE REQUEST narrative
      *
     C     P1PNDPCL      IFNE      *ZERO
     C                   MOVEL     ' CLOSURE'    DDDELT
     C                   MOVE      'REQUEST'     DDDELT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Customer Number
      *
     C                   MOVEL     P1PNCNUM      DDCSNM
      *
      ** Portfolio Reference
      *
     C                   MOVEL     P1PNPTFR      DDPREF
      *
      ** Portfolio Currency
      *
     C                   EVAL      DDPTCY = P1PNPTCY
      *
      ** Portfolio Narrative
      *
     C                   EVAL      DDPTFN = P1PNPTFN
      *
      ** Date Opened
      *
     C                   EVAL      ZDAYNO = P1PNDPOP
     C                   EXSR      SRDATE
     C                   MOVE      ZDATE         DDDPOP
      *
      ** Date Closed
      *
     C     P1PNDPCL      IFNE      0
     C                   EVAL      ZDAYNO = P1PNDPCL
     C                   EXSR      SRDATE
     C                   MOVE      ZDATE         DDDPCL
     C                   ELSE
     C     PDDACTN       IFEQ      'C'
     C                   EVAL      ZDAYNO = BJRDNB
     C                   EXSR      SRDATE
     C                   MOVE      ZDATE         DDDPCL
     C                   ELSE
     C                   MOVE      *BLANKS       DDDPCL
     C                   ENDIF
     C                   ENDIF
      *
      ** Profit Centre
      *
     C     CAC003        IFEQ      'Y'
     C     BGN0ST        ANDEQ     'Y'
     C                   EVAL      DDPRF2 = P1PNPRFC
     C                   ENDIF
      *
      ** Custody fee group code
      *
     C     S01464        IFEQ      'Y'
     C     FBFGCP        ANDEQ     'Y'
     C                   EVAL      DDCFGC = P1PNCFGC
     C                   ENDIF
      *
      ** Account Sequence
      *
     C     BGFUOP        IFEQ      'Y'
     C     P1PNACSQ      IFNE      0
     C                   MOVE      P1PNACSQ      DDACSQ
     C                   ELSE
     C                   MOVE      *BLANKS       DDACSQ
     C                   ENDIF
     C                   ENDIF
      *
      ** Continue converting fields to their screen format only if
      ** customer is a Portfolio Management Customer.
      *
     C     PMCUST        IFEQ      'Y'
      *
     C/COPY WNCPYSRC,HUT113_006                                                            HUT113
      *
      ** Investment details
      *
     C                   EVAL      DDIPIN = P1PNIPIN
     C                   EVAL      DDCYIN = P1PNCYIN
     C                   EVAL      DDYPIN = P1PNYPIN
     C                   EVAL      DDNPIN = P1PNNPIN
      *
      ** Managed Indicator
      *
     C                   EVAL      DDMNGI = P1PNMNGI
      *
      ** Report Past Year Performance
      *
     C                   EVAL      DDRPYP = P1PNRPYP
      *
      ** Portfolio Type
      *
     C                   EVAL      DDPTFT = P1PNPTFT
      *
      ** Pledge Start Date
      *
     C     P1PNPDGS      IFNE      0
     C                   EVAL      ZDAYNO = P1PNPDGS
     C                   EXSR      SRDATE
     C                   MOVE      ZDATE         DDPDGS
     C                   ELSE
     C                   MOVE      *BLANKS       DDPDGS
     C                   ENDIF
      *
      ** Pledge finish date
      *
     C     P1PNPDGF      IFNE      0
     C     P1PNPDGF      ANDNE     99999
     C                   EVAL      ZDAYNO = P1PNPDGF
     C                   EXSR      SRDATE
     C                   MOVE      ZDATE         DDPDGF
     C                   ELSE
     C                   MOVE      *BLANKS       DDPDGF
     C                   ENDIF
      *
      ** Valuation frequency
      *
     C                   EVAL      DDVLFQ = P1PNVLFQ
      *
      ** Valuation day in month
      *
     C     P1PNVLDM      IFEQ      0
     C                   MOVE      *BLANKS       DDVLDM
     C                   ELSE
     C                   MOVE      P1PNVLDM      DDVLDM
     C                   ENDIF
      *
      ** Next valuation date
      *
     C     P1PNVLND      IFNE      0
     C                   EVAL      ZDAYNO = P1PNVLND
     C                   EXSR      SRDATE
     C                   MOVE      ZDATE         DDVLND
     C                   ELSE
     C                   MOVE      *BLANKS       DDVLND
     C                   ENDIF
      *
      ** Summary Section Details
      *
     C                   EVAL      DDS9VR = P1PNS9VR
     C                   EVAL      DDS0VR = P1PNS0VR
     C                   EVAL      DDS1VR = P1PNS1VR
     C                   EVAL      DDS2VR = P1PNS2VR
     C                   EVAL      DDS3VR = P1PNS3VR
     C                   EVAL      DDS4VR = P1PNS4VR
     C                   EVAL      DDS5VR = P1PNS5VR
     C                   EVAL      DDS6VR = P1PNS6VR
     C                   EVAL      DDS7VR = P1PNS7VR
     C                   EVAL      DDS8VR = P1PNS8VR
      *
      ** Tax year start month
      *
     C     P1PNTYSM      IFNE      0
     C                   MOVE      P1PNTYSM      DDTYSM
     C                   ELSE
     C                   MOVE      *BLANKS       DDTYSM
     C                   ENDIF
      *
      ** Additional Period
      *
     C                   EVAL      DDADPP = P1PNADPP
      *
      ** Performance Net Gross of Tax
      *
     C                   EVAL      DDPMNG = P1PNPMNG
      *
      ** Performance Start Date
      *
     C     P1PNPSDT      IFNE      0
     C     P1PNPSDT      ANDNE     99999
     C                   EVAL      ZDAYNO = P1PNPSDT
     C                   EXSR      SRDATE
     C                   MOVE      ZDATE         DDPSDT
     C                   ELSE
     C                   MOVE      *BLANKS       DDPSDT
     C                   ENDIF
      *
      ** Cashflow frequency
      *
     C                   EVAL      DDCASF = P1PNCASF
      *
      ** Cashflow day in month
      *
     C     P1PNCASD      IFNE      0
     C                   MOVE      P1PNCASD      DDCASD
     C                   ELSE
     C                   MOVE      *BLANKS       DDCASD
     C                   ENDIF
      *
      ** Next Cashflow Date
      *
     C     P1PNCASN      IFNE      0
     C                   EVAL      ZDAYNO = P1PNCASN
     C                   EXSR      SRDATE
     C                   MOVE      ZDATE         DDCASN
     C                   ELSE
     C                   MOVE      *BLANKS       DDCASN
     C                   ENDIF
      *
      ** Policy Code
      *
     C                   EVAL      DDPOLC = P1PNPOLC
      *
     C/COPY WNCPYSRC,HUT113_007                                                            HUT113
      *
     C                   ENDIF
      *                                                                         CPB002
      ** Management Type                                                        CPB002
      *                                                                         CPB002
     C                   MOVE      P1PNMGTP      DDMGTP                         CPB002
      *                                                                         CPB002
      ** Investment Profile Code                                                CPB002
      *                                                                         CPB002
     C                   MOVE      P1PNINTP      DDINTP                         CPB002
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDATE - Routine to convert day number to date               *
      *                                                               *
      *****************************************************************
      *
     C     SRDATE        BEGSR
      *
     C                   EVAL      ZADATE = *BLANKS
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
     C                   ENDSR
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
     C                   PARM                    RETCODEIN
      *
      ** Portfolio Definition Details retrieved from file
      ** - in file format
     C                   PARM                    PPORTFILFMT
      *
      ** Action code from incoming transaction
     C                   PARM                    PDDACTN           1
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST            1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB            5 0
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN            1
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST            1
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP            1
      *
      ** SDMMOD - Futures & Options
     C                   PARM                    BGFUOP            1
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
      ** Portfolio Definition Details retrieved from file
      ** - converted to screen format
     C                   PARM                    PMPFDM
      *
      ** Investment Policy Indicators retrieved from file
      ** - converted to screen format
     C                   PARM                    PCURINVEST
      *
      ** Date Opened from file - converted to screen format
     C                   PARM                    DDDPOP            6
      *
      ** CLOSED/CLOSURE REQUEST narrative - for display
     C                   PARM                    DDDELT           16
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C/COPY WNCPYSRC,HUT113_008                                                            HUT113
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
